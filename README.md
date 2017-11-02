meta WWW::req .. for various api calls to various json api bits, less code
duplicated elsewhere is good!

note: one must define 'sub setup_ua_creds { }' in any package that extends
this one, and inside this function, one must call:

	$this->urlbase("https://api.example.com/");
	and
	$this->json_name("example-ws");
or fireworks will result!

