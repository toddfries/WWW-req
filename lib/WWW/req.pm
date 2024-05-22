# Copyright (c) 2017 Todd T. Fries <todd@fries.net>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

package WWW::req;

use Moose;

use HTTP::Request;
use JSON;
use LWP::UserAgent;
use URI::Encode;

has 'urlbase' => (is => 'rw', isa => 'Str', required => 0);
has 'json_name' => (is => 'rw', isa => 'Str', required => 0);

sub get {
	my ($me, $call) = @_;

	if (!defined($me->{ua})) {
		$me->{ua} = LWP::UserAgent->new;
		$me->{ua}->env_proxy();
		$me->{ua}->timeout(60);
		$me->setup_ua_creds;
	}

	my $url = $me->urlbase().$call;

	my $req = HTTP::Request->new(GET => $url);

	if (!defined($req)) {
		return "EINVAL URL: $url";
	}

	my $res = $me->{ua}->request( $req );

	if (!defined($res)) {
		return "EBADF result URL='$url'";
	}

	return $me->parse_json( $res, $me->json_name);
}

sub post {
	my ($me, $call, $data, $rtype) = @_;
	if (!defined($rtype)) {
		$rtype = "form";
	}

	if (!defined($me->{ua})) {
		$me->{ua} = LWP::UserAgent->new;
		$me->{ua}->env_proxy();
		$me->{ua}->timeout(60);
		$me->setup_ua_creds;
	}

	my $req;
	my $header;
	my $url = $me->urlbase().$call;
	my $encoded_data = "";

	if ($rtype eq "form") {
		$header = [ 'Content-Type' => 'application/x-www-form-urlencoded' ];
		my $uri = URI::Encode->new();
		foreach my $k (keys %{ $data }) {
			$encoded_data .= "$k=" . $uri->encode($data->{$k}) . "&";
		}
		chop($encoded_data);
	} elsif ($rtype eq "json") {
		$header = [ 'Content-Type' => 'application/json; charset=UTF-8' ];
		$encoded_data = encode_json($data);
	}

	$req = HTTP::Request->new(POST => $url, $header, $encoded_data);
	if (!defined($req)) {
		return "EINVAL URL: $url";
	}

	my $res = $me->{ua}->request( $req );

	if (!defined($res)) {
		return "EBADF result URL='$url'";
	}

	return $me->parse_json( $res, $me->json_name);
}

sub parse_json {
	my ($me, $res, $name) = @_;

	my $str = $res->content;
	if (ref($str) ne "") {
		$str = $res->content_ref;
	}
	if (!defined($str)) {
		printf "%s has undef str\n", $name;
		return undef;
	}
	if (length($str) < 1) {
		printf "%s has empty str\n", $name;
		return undef;
	}
	if (!defined($me->{json})) {
		$me->{json} = JSON->new->allow_nonref;
	}

	my $parsed;
	#printf "%s: json->decode( '%s' ) .. pre\n", $name, $str;

	eval {
		$parsed = $me->{json}->decode( $str );
	};
	if ($@) {
		die(sprintf("%s: json->decode('%s') Error %s\n", $name,
		    $str, $@
));
	}
	return $parsed;
}

1;
