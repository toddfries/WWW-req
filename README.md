# WWW-req
```
Subject: WWW-req - wrapper for json requests to avoid duplicate code elsewhere
From: Todd T. Fries <todd@fries.net>
To: anyone reading this
```

I got tired of making the same duplicate code everywhere I decoded json in
various api implementations.  So I put it here so it is not duplicated nor do
I have to duplicate the maintenance of it everywhere.

Please note: you must define 'sub setup_ua_creds { }' in any package that
extends this one, and inside this function, one must call:

```
	$this->urlbase("https://api.example.com/");
	and
	$this->json_name("example-ws");
```

or fireworks will result!

Example usage can be found in [WWW-Hetzner](https://github.com/toddfries/WWW-Hetzner).

Enjoy!

Thanks,

```
--
Todd Fries .. todd@fries.net

 ____________________________________________
|                                            \  1.636.410.0632 (voice)
| Free Daemon Consulting, LLC                \  1.405.227.9094 (voice)
| http://FreeDaemonConsulting.com            \  1.866.792.3418 (FAX)
| PO Box 16169, Oklahoma City, OK 73113-2169 \  sip:freedaemon@ekiga.net
| "..in support of free software solutions." \  sip:4052279094@ekiga.net
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                                 
              37E7 D3EB 74D0 8D66 A68D  B866 0326 204E 3F42 004A
                        http://todd.fries.net/pgp.txt
```

If you find this useful and wish to donate, I accept donations:

- BTC: [1JLaXmTHoEZLzQYToUR8aUSWtBn3nZf8YS](bitcoin:11JLaXmTHoEZLzQYToUR8aUSWtBn3nZf8YS)
- DCR: [Dscjs2rnk8xBt2Q1ePivFt5yjuzryGv2sh9](decredcjs2rnk8xBt2Q1ePivFt5yjuzryGv2sh9)

