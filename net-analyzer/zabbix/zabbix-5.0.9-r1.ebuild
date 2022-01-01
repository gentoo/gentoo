# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# needed to make webapp-config dep optional
WEBAPP_OPTIONAL="yes"
inherit flag-o-matic webapp java-pkg-opt-2 systemd toolchain-funcs go-module
EGO_SUM=(
	"github.com/BurntSushi/locker v0.0.0-20171006230638-a6e239ea1c69 h1:+tu3HOoMXB7RXEINRVIpxJCT+KdYiI7LAEAUrOw3dIU="
	"github.com/BurntSushi/locker v0.0.0-20171006230638-a6e239ea1c69/go.mod h1:L1AbZdiDllfyYH5l5OkAaZtk7VkWe89bPJFmnDBNHxg="
	"github.com/BurntSushi/toml v0.3.1/go.mod h1:xHWCNGjB5oqiDr8zfno3MHue2Ht5sIBksp03qcyfWMU="
	"github.com/cockroachdb/apd v1.1.0 h1:3LFP3629v+1aKXU5Q37mxmRxX/pIu1nijXydLShEq5I="
	"github.com/cockroachdb/apd v1.1.0/go.mod h1:8Sl8LxpKi29FqWXR16WEFZRNSz3SoPzUzeMeY4+DwBQ="
	"github.com/coreos/go-systemd v0.0.0-20190321100706-95778dfbb74e/go.mod h1:F5haX7vjVVG0kc13fIWeqUViNPyEJxv/OmvnBo0Yme4="
	"github.com/coreos/go-systemd v0.0.0-20190719114852-fd7a80b32e1f/go.mod h1:F5haX7vjVVG0kc13fIWeqUViNPyEJxv/OmvnBo0Yme4="
	"github.com/creack/pty v1.1.7/go.mod h1:lj5s0c3V2DBrqTV7llrYr5NG6My20zk30Fl46Y7DoTY="
	"github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38="
	"github.com/davecgh/go-spew v1.1.1 h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c="
	"github.com/davecgh/go-spew v1.1.1/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38="
	"github.com/dustin/gomemcached v0.0.0-20160817010731-a2284a01c143 h1:K9CFK8HRZWzmoIWbpA7u0XYLggCyfa/N77eVaq/nUiA="
	"github.com/dustin/gomemcached v0.0.0-20160817010731-a2284a01c143/go.mod h1:BLhrehfVmtABJWBZTJV8HyPWCSZoiMzjjcZ3+vHHhPI="
	"github.com/fsnotify/fsnotify v1.4.9 h1:hsms1Qyu0jgnwNXIxa+/V/PDsU6CfLf6CNO8H7IWoS4="
	"github.com/fsnotify/fsnotify v1.4.9/go.mod h1:znqG4EE+3YCdAaPaxE2ZRY/06pZUdp0tY4IgpuI1SZQ="
	"github.com/go-ldap/ldap v3.0.3+incompatible h1:HTeSZO8hWMS1Rgb2Ziku6b8a7qRIZZMHjsvuZyatzwk="
	"github.com/go-ldap/ldap v3.0.3+incompatible/go.mod h1:qfd9rJvER9Q0/D/Sqn1DfHRoBp40uXYvFoEVrNEPqRc="
	"github.com/go-logfmt/logfmt v0.5.0 h1:TrB8swr/68K7m9CcGut2g3UOihhbcbiMAYiuTXdEih4="
	"github.com/go-logfmt/logfmt v0.5.0/go.mod h1:wCYkCAKZfumFQihp8CzCvQ3paCTfi41vtzG1KdI/P7A="
	"github.com/go-ole/go-ole v1.2.4 h1:nNBDSCOigTSiarFpYE9J/KtEA1IOW4CNeqT9TQDqCxI="
	"github.com/go-ole/go-ole v1.2.4/go.mod h1:XCwSNxSkXRo4vlyPy93sltvi/qJq0jqQhjqQNIwKuxM="
	"github.com/go-sql-driver/mysql v1.5.0 h1:ozyZYNQW3x3HtqT1jira07DN2PArx2v7/mN66gGcHOs="
	"github.com/go-sql-driver/mysql v1.5.0/go.mod h1:DCzpHaOWr8IXmIStZouvnhqoel9Qv2LBy8hT2VhHyBg="
	"github.com/go-stack/stack v1.8.0/go.mod h1:v0f6uXyyMGvRgIKkXu+yp6POWl0qKG85gN/melR3HDY="
	"github.com/godbus/dbus v4.1.0+incompatible h1:WqqLRTsQic3apZUK9qC5sGNfXthmPXzUZ7nQPrNITa4="
	"github.com/godbus/dbus v4.1.0+incompatible/go.mod h1:/YcGZj5zSblfDWMMoOzV4fas9FZnQYTkDnsGvmh2Grw="
	"github.com/godror/godror v0.20.1 h1:s/ehD65nfVzWR2MrZGChDkLvVPlIVxbt+Jpzfwkl1c8="
	"github.com/godror/godror v0.20.1/go.mod h1:YlPoIf962ZZKPM5Xqa8NxmGgck39pi51tqAs+K3IaFM="
	"github.com/gofrs/uuid v3.2.0+incompatible h1:y12jRkkFxsd7GpqdSZ+/KCs/fJbqpEXSGd4+jfEaewE="
	"github.com/gofrs/uuid v3.2.0+incompatible/go.mod h1:b2aQJv3Z4Fp6yNu3cdSllBxTCLRxnplIgP/c0N/04lM="
	"github.com/google/go-cmp v0.4.0 h1:xsAVV57WRhGj6kEIi8ReJzQlHHqcBYCElAvkovg3B/4="
	"github.com/google/go-cmp v0.4.0/go.mod h1:v8dTdLbMG2kIc/vJvl+f65V22dbkXbowE6jgT/gNBxE="
	"github.com/google/renameio v0.1.0/go.mod h1:KWCgfxg9yswjAJkECMjeO8J8rahYeXnNhOm40UhjYkI="
	"github.com/jackc/chunkreader v1.0.0 h1:4s39bBR8ByfqH+DKm8rQA3E1LHZWB9XWcrz8fqaZbe0="
	"github.com/jackc/chunkreader v1.0.0/go.mod h1:RT6O25fNZIuasFJRyZ4R/Y2BbhasbmZXF9QQ7T3kePo="
	"github.com/jackc/chunkreader/v2 v2.0.0/go.mod h1:odVSm741yZoC3dpHEUXIqA9tQRhFrgOHwnPIn9lDKlk="
	"github.com/jackc/chunkreader/v2 v2.0.1 h1:i+RDz65UE+mmpjTfyz0MoVTnzeYxroil2G82ki7MGG8="
	"github.com/jackc/chunkreader/v2 v2.0.1/go.mod h1:odVSm741yZoC3dpHEUXIqA9tQRhFrgOHwnPIn9lDKlk="
	"github.com/jackc/pgconn v0.0.0-20190420214824-7e0022ef6ba3/go.mod h1:jkELnwuX+w9qN5YIfX0fl88Ehu4XC3keFuOJJk9pcnA="
	"github.com/jackc/pgconn v0.0.0-20190824142844-760dd75542eb/go.mod h1:lLjNuW/+OfW9/pnVKPazfWOgNfH2aPem8YQ7ilXGvJE="
	"github.com/jackc/pgconn v0.0.0-20190831204454-2fabfa3c18b7/go.mod h1:ZJKsE/KZfsUgOEh9hBm+xYTstcNHg7UPMVJqRfQxq4s="
	"github.com/jackc/pgconn v1.4.0/go.mod h1:Y2O3ZDF0q4mMacyWV3AstPJpeHXWGEetiFttmq5lahk="
	"github.com/jackc/pgconn v1.5.0 h1:oFSOilzIZkyg787M1fEmyMfOUUvwj0daqYMfaWwNL4o="
	"github.com/jackc/pgconn v1.5.0/go.mod h1:QeD3lBfpTFe8WUnPZWN5KY/mB8FGMIYRdd8P8Jr0fAI="
	"github.com/jackc/pgconn v1.5.1-0.20200601181101-fa742c524853/go.mod h1:QeD3lBfpTFe8WUnPZWN5KY/mB8FGMIYRdd8P8Jr0fAI="
	"github.com/jackc/pgconn v1.6.5-0.20200905181414-0d4f029683fc h1:9ThyBXKdyBFN2Y1NSCPGCA0kdWCNpd9u4SKWwtr6GfU="
	"github.com/jackc/pgconn v1.6.5-0.20200905181414-0d4f029683fc/go.mod h1:gm9GeeZiC+Ja7JV4fB/MNDeaOqsCrzFiZlLVhAompxk="
	"github.com/jackc/pgio v1.0.0 h1:g12B9UwVnzGhueNavwioyEEpAmqMe1E/BN9ES+8ovkE="
	"github.com/jackc/pgio v1.0.0/go.mod h1:oP+2QK2wFfUWgr+gxjoBH9KGBb31Eio69xUb0w5bYf8="
	"github.com/jackc/pgmock v0.0.0-20190831213851-13a1b77aafa2 h1:JVX6jT/XfzNqIjye4717ITLaNwV9mWbJx0dLCpcRzdA="
	"github.com/jackc/pgmock v0.0.0-20190831213851-13a1b77aafa2/go.mod h1:fGZlG77KXmcq05nJLRkk0+p82V8B8Dw8KN2/V9c/OAE="
	"github.com/jackc/pgpassfile v1.0.0 h1:/6Hmqy13Ss2zCq62VdNG8tM1wchn8zjSGOBJ6icpsIM="
	"github.com/jackc/pgpassfile v1.0.0/go.mod h1:CEx0iS5ambNFdcRtxPj5JhEz+xB6uRky5eyVu/W2HEg="
	"github.com/jackc/pgproto3 v1.1.0 h1:FYYE4yRw+AgI8wXIinMlNjBbp/UitDJwfj5LqqewP1A="
	"github.com/jackc/pgproto3 v1.1.0/go.mod h1:eR5FA3leWg7p9aeAqi37XOTgTIbkABlvcPB3E5rlc78="
	"github.com/jackc/pgproto3/v2 v2.0.0-alpha1.0.20190420180111-c116219b62db/go.mod h1:bhq50y+xrl9n5mRYyCBFKkpRVTLYJVWeCc+mEAI3yXA="
	"github.com/jackc/pgproto3/v2 v2.0.0-alpha1.0.20190609003834-432c2951c711/go.mod h1:uH0AWtUmuShn0bcesswc4aBTWGvw0cAxIJp+6OB//Wg="
	"github.com/jackc/pgproto3/v2 v2.0.0-rc3/go.mod h1:ryONWYqW6dqSg1Lw6vXNMXoBJhpzvWKnT95C46ckYeM="
	"github.com/jackc/pgproto3/v2 v2.0.0-rc3.0.20190831210041-4c03ce451f29/go.mod h1:ryONWYqW6dqSg1Lw6vXNMXoBJhpzvWKnT95C46ckYeM="
	"github.com/jackc/pgproto3/v2 v2.0.1 h1:Rdjp4NFjwHnEslx2b66FfCI2S0LhO4itac3hXz6WX9M="
	"github.com/jackc/pgproto3/v2 v2.0.1/go.mod h1:WfJCnwN3HIg9Ish/j3sgWXnAfK8A9Y0bwXYU5xKaEdA="
	"github.com/jackc/pgproto3/v2 v2.0.4 h1:RHkX5ZUD9bl/kn0f9dYUWs1N7Nwvo1wwUYvKiR26Zco="
	"github.com/jackc/pgproto3/v2 v2.0.4/go.mod h1:WfJCnwN3HIg9Ish/j3sgWXnAfK8A9Y0bwXYU5xKaEdA="
	"github.com/jackc/pgservicefile v0.0.0-20200307190119-3430c5407db8 h1:Q3tB+ExeflWUW7AFcAhXqk40s9mnNYLk1nOkKNZ5GnU="
	"github.com/jackc/pgservicefile v0.0.0-20200307190119-3430c5407db8/go.mod h1:vsD4gTJCa9TptPL8sPkXrLZ+hDuNrZCnj29CQpr4X1E="
	"github.com/jackc/pgservicefile v0.0.0-20200714003250-2b9c44734f2b h1:C8S2+VttkHFdOOCXJe+YGfa4vHYwlt4Zx+IVXQ97jYg="
	"github.com/jackc/pgservicefile v0.0.0-20200714003250-2b9c44734f2b/go.mod h1:vsD4gTJCa9TptPL8sPkXrLZ+hDuNrZCnj29CQpr4X1E="
	"github.com/jackc/pgtype v0.0.0-20190421001408-4ed0de4755e0/go.mod h1:hdSHsc1V01CGwFsrv11mJRHWJ6aifDLfdV3aVjFF0zg="
	"github.com/jackc/pgtype v0.0.0-20190824184912-ab885b375b90/go.mod h1:KcahbBH1nCMSo2DXpzsoWOAfFkdEtEJpPbVLq8eE+mc="
	"github.com/jackc/pgtype v0.0.0-20190828014616-a8802b16cc59/go.mod h1:MWlu30kVJrUS8lot6TQqcg7mtthZ9T0EoIBFiJcmcyw="
	"github.com/jackc/pgtype v1.2.0/go.mod h1:5m2OfMh1wTK7x+Fk952IDmI4nw3nPrvtQdM0ZT4WpC0="
	"github.com/jackc/pgtype v1.3.1-0.20200510190516-8cd94a14c75a/go.mod h1:vaogEUkALtxZMCH411K+tKzNpwzCKU+AnPzBKZ+I+Po="
	"github.com/jackc/pgtype v1.3.1-0.20200606141011-f6355165a91c/go.mod h1:cvk9Bgu/VzJ9/lxTO5R5sf80p0DiucVtN7ZxvaC4GmQ="
	"github.com/jackc/pgtype v1.4.3-0.20200905161353-e7d2b057a716 h1:DrP52jA32liWkjCF/g3rYC1QjnRh6kvyXaZSevAtlqE="
	"github.com/jackc/pgtype v1.4.3-0.20200905161353-e7d2b057a716/go.mod h1:JCULISAZBFGrHaOXIIFiyfzW5VY0GRitRr8NeJsrdig="
	"github.com/jackc/pgx/v4 v4.0.0-20190420224344-cc3461e65d96/go.mod h1:mdxmSJJuR08CZQyj1PVQBHy9XOp5p8/SHH6a0psbY9Y="
	"github.com/jackc/pgx/v4 v4.0.0-20190421002000-1b8f0016e912/go.mod h1:no/Y67Jkk/9WuGR0JG/JseM9irFbnEPbuWV2EELPNuM="
	"github.com/jackc/pgx/v4 v4.0.0-pre1.0.20190824185557-6972a5742186/go.mod h1:X+GQnOEnf1dqHGpw7JmHqHc1NxDoalibchSk9/RWuDc="
	"github.com/jackc/pgx/v4 v4.5.0/go.mod h1:EpAKPLdnTorwmPUUsqrPxy5fphV18j9q3wrfRXgo+kA="
	"github.com/jackc/pgx/v4 v4.6.1-0.20200510190926-94ba730bb1e9/go.mod h1:t3/cdRQl6fOLDxqtlyhe9UWgfIi9R8+8v8GKV5TRA/o="
	"github.com/jackc/pgx/v4 v4.6.1-0.20200606145419-4e5062306904/go.mod h1:ZDaNWkt9sW1JMiNn0kdYBaLelIhw7Pg4qd+Vk6tw7Hg="
	"github.com/jackc/pgx/v4 v4.8.2-0.20200910143026-040df1ccef85 h1:G5gbS1Q6cq7/Q1Z1CUqU9IKWfar2R1P6CE0zkKClEG0="
	"github.com/jackc/pgx/v4 v4.8.2-0.20200910143026-040df1ccef85/go.mod h1:OWJpVJk5U9XXEiYHeQ+5NtRt82Y5c8gvIZj96kl27Ow="
	"github.com/jackc/puddle v0.0.0-20190413234325-e4ced69a3a2b/go.mod h1:m4B5Dj62Y0fbyuIc15OsIqK0+JU8nkqQjsgx7dvjSWk="
	"github.com/jackc/puddle v0.0.0-20190608224051-11cab39313c9/go.mod h1:m4B5Dj62Y0fbyuIc15OsIqK0+JU8nkqQjsgx7dvjSWk="
	"github.com/jackc/puddle v1.1.0 h1:musOWczZC/rSbqut475Vfcczg7jJsdUQf0D6oKPLgNU="
	"github.com/jackc/puddle v1.1.0/go.mod h1:m4B5Dj62Y0fbyuIc15OsIqK0+JU8nkqQjsgx7dvjSWk="
	"github.com/jackc/puddle v1.1.1/go.mod h1:m4B5Dj62Y0fbyuIc15OsIqK0+JU8nkqQjsgx7dvjSWk="
	"github.com/jackc/puddle v1.1.2-0.20200821025810-91d0159cc97a h1:ec2LCBkfN1pOq0PhLRH/QitjSXr9s2dnh0gOFyohxHM="
	"github.com/jackc/puddle v1.1.2-0.20200821025810-91d0159cc97a/go.mod h1:m4B5Dj62Y0fbyuIc15OsIqK0+JU8nkqQjsgx7dvjSWk="
	"github.com/kisielk/gotool v1.0.0/go.mod h1:XhKaO+MFFWcvkIS/tQcRk01m1F5IRFswLeQ+oQHNcck="
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod h1:T0+1ngSBFLxvqU3pZ+m/2kptfBszLMUkC4ZK/EgS/cQ="
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2 h1:DB17ag19krx9CFsz4o3enTrPXyIXCl+2iCXH/aMAp9s="
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2/go.mod h1:T0+1ngSBFLxvqU3pZ+m/2kptfBszLMUkC4ZK/EgS/cQ="
	"github.com/kr/pretty v0.1.0 h1:L/CwN0zerZDmRFUapSPitk6f+Q3+0za1rQkzVuMiMFI="
	"github.com/kr/pretty v0.1.0/go.mod h1:dAy3ld7l9f0ibDNOQOHHMYYIIbhfbHSm3C4ZsoJORNo="
	"github.com/kr/pty v1.1.1/go.mod h1:pFQYn66WHrOpPYNljwOMqo10TkYh1fy3cYio2l3bCsQ="
	"github.com/kr/pty v1.1.8/go.mod h1:O1sed60cT9XZ5uDucP5qwvh+TE3NnUj51EiZO/lmSfw="
	"github.com/kr/text v0.1.0 h1:45sCR5RtlFHMR4UwH9sdQ5TC8v0qDQCHnXt+kaKSTVE="
	"github.com/kr/text v0.1.0/go.mod h1:4Jbv+DJW3UT/LiOwJeYQe1efqtUx/iVham/4vfdArNI="
	"github.com/lib/pq v1.0.0/go.mod h1:5WUZQaWbwv1U+lTReE5YruASi9Al49XbQIvNi/34Woo="
	"github.com/lib/pq v1.1.0/go.mod h1:5WUZQaWbwv1U+lTReE5YruASi9Al49XbQIvNi/34Woo="
	"github.com/lib/pq v1.2.0 h1:LXpIM/LZ5xGFhOpXAQUIMM1HdyqzVYM13zNdjCEEcA0="
	"github.com/lib/pq v1.2.0/go.mod h1:5WUZQaWbwv1U+lTReE5YruASi9Al49XbQIvNi/34Woo="
	"github.com/lib/pq v1.3.0 h1:/qkRGz8zljWiDcFvgpwUpwIAPu3r07TDvs3Rws+o/pU="
	"github.com/lib/pq v1.3.0/go.mod h1:5WUZQaWbwv1U+lTReE5YruASi9Al49XbQIvNi/34Woo="
	"github.com/mattn/go-colorable v0.1.1/go.mod h1:FuOcm+DKB9mbwrcAfNl7/TZVBZ6rcnceauSikq3lYCQ="
	"github.com/mattn/go-colorable v0.1.2/go.mod h1:U0ppj6V5qS13XJ6of8GYAs25YV2eR4EVcfRqFIhoBtE="
	"github.com/mattn/go-colorable v0.1.6/go.mod h1:u6P/XSegPjTcexA+o6vUJrdnUu04hMope9wVRipJSqc="
	"github.com/mattn/go-isatty v0.0.5/go.mod h1:Iq45c/XA43vh69/j3iqttzPXn0bhXyGjM0Hdxcsrc5s="
	"github.com/mattn/go-isatty v0.0.7/go.mod h1:Iq45c/XA43vh69/j3iqttzPXn0bhXyGjM0Hdxcsrc5s="
	"github.com/mattn/go-isatty v0.0.8/go.mod h1:Iq45c/XA43vh69/j3iqttzPXn0bhXyGjM0Hdxcsrc5s="
	"github.com/mattn/go-isatty v0.0.9/go.mod h1:YNRxwqDuOph6SZLI9vUUz6OYw3QyUt7WiY2yME+cCiQ="
	"github.com/mattn/go-isatty v0.0.12/go.mod h1:cbi8OIDigv2wuxKPP5vlRcQ1OAZbq2CE4Kysco4FUpU="
	"github.com/mattn/go-sqlite3 v2.0.3+incompatible h1:gXHsfypPkaMZrKbD5209QV9jbUTJKjyR5WD3HYQSd+U="
	"github.com/mattn/go-sqlite3 v2.0.3+incompatible/go.mod h1:FPy6KqzDD04eiIsT53CuJW3U88zkxoIYsOqkbpncsNc="
	"github.com/mediocregopher/radix/v3 v3.5.0 h1:8QHQmNh2ne9aFxTD3z63u/bkPPiOtknHoz80oP8EA/E="
	"github.com/mediocregopher/radix/v3 v3.5.0/go.mod h1:8FL3F6UQRXHXIBSPUs5h0RybMF8i4n7wVopoX3x7Bv8="
	"github.com/memcachier/mc/v3 v3.0.1 h1:Os/fUl/8c+hc1qWgjv5hNK0JI6GxKUOuehzB/UmjLP0="
	"github.com/memcachier/mc/v3 v3.0.1/go.mod h1:GzjocBahcXPxt2cmqzknrgqCOmMxiSzhVKPOe90Tpug="
	"github.com/natefinch/npipe v0.0.0-20160621034901-c1b8fa8bdcce h1:TqjP/BTDrwN7zP9xyXVuLsMBXYMt6LLYi55PlrIcq8U="
	"github.com/natefinch/npipe v0.0.0-20160621034901-c1b8fa8bdcce/go.mod h1:ifHPsLndGGzvgzcaXUvzmt6LxKT4pJ+uzEhtnMt+f7A="
	"github.com/omeid/go-yarn v0.0.1 h1:mUQExNwUrYn7tZRwQdsUuoQWHIujtjjpjb/PAtUj9dk="
	"github.com/omeid/go-yarn v0.0.1/go.mod h1:JYxmAvShSw7YmX/9vFsccpJE4o/KW111eUh3n/TQ5h8="
	"github.com/pkg/errors v0.8.1/go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0="
	"github.com/pkg/errors v0.9.1 h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4="
	"github.com/pkg/errors v0.9.1/go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0="
	"github.com/pmezard/go-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM="
	"github.com/pmezard/go-difflib v1.0.0/go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ/4="
	"github.com/rogpeppe/go-internal v1.3.0/go.mod h1:M8bDsm7K2OlrFYOpmOWEs/qY81heoFRclV5y23lUDJ4="
	"github.com/rs/xid v1.2.1/go.mod h1:+uKXf+4Djp6Md1KODXJxgGQPKngRmWyn10oCKFzNHOQ="
	"github.com/rs/zerolog v1.13.0/go.mod h1:YbFCdg8HfsridGWAh22vktObvhZbQsZXe4/zB0OKkWU="
	"github.com/rs/zerolog v1.15.0/go.mod h1:xYTKnLHcpfU2225ny5qZjxnj9NvkumZYjJHlAThCjNc="
	"github.com/satori/go.uuid v1.2.0/go.mod h1:dA0hQrYB0VpLJoorglMZABFdXlWrHn1NEOzdhQKdks0="
	"github.com/shopspring/decimal v0.0.0-20180709203117-cd690d0c9e24 h1:pntxY8Ary0t43dCZ5dqY4YTJCObLY1kIXl0uzMv+7DE="
	"github.com/shopspring/decimal v0.0.0-20180709203117-cd690d0c9e24/go.mod h1:M+9NzErvs504Cn4c5DxATwIqPbtswREoFCre64PpcG4="
	"github.com/shopspring/decimal v0.0.0-20200227202807-02e2044944cc h1:jUIKcSPO9MoMJBbEoyE/RJoE8vz7Mb8AjvifMMwSyvY="
	"github.com/shopspring/decimal v0.0.0-20200227202807-02e2044944cc/go.mod h1:DKyhrW/HYNuLGql+MJL6WCR6knT2jwCFRcu2hWCYk4o="
	"github.com/sirupsen/logrus v1.4.1/go.mod h1:ni0Sbl8bgC9z8RoU9G6nDWqqs/fq4eDPysMBDgk/93Q="
	"github.com/sirupsen/logrus v1.4.2 h1:SPIRibHv4MatM3XXNO2BJeFLZwZ2LvZgfQ5+UNI2im4="
	"github.com/sirupsen/logrus v1.4.2/go.mod h1:tLMulIdttU9McNUspp0xgXVQah82FyeX6MwdIuYE2rE="
	"github.com/stretchr/objx v0.1.0/go.mod h1:HFkY916IF+rwdDfMAkV7OtwuqBVzrE8GR6GFx+wExME="
	"github.com/stretchr/objx v0.1.1/go.mod h1:HFkY916IF+rwdDfMAkV7OtwuqBVzrE8GR6GFx+wExME="
	"github.com/stretchr/objx v0.2.0/go.mod h1:qt09Ya8vawLte6SNmTgCsAVtYtaKzEcn8ATUoHMkEqE="
	"github.com/stretchr/testify v1.2.2/go.mod h1:a8OnRcib4nhh0OaRAV+Yts87kKdq0PP7pXfy6kDkUVs="
	"github.com/stretchr/testify v1.3.0/go.mod h1:M5WIy9Dh21IEIfnGCwXGc5bZfKNJtfHm1UVUgZn+9EI="
	"github.com/stretchr/testify v1.4.0/go.mod h1:j7eGeouHqKxXV5pUuKE4zz7dFj8WfuZ+81PSLYec5m4="
	"github.com/stretchr/testify v1.5.1 h1:nOGnQDM7FYENwehXlg/kFVnos3rEvtKTjRvOWSzb6H4="
	"github.com/stretchr/testify v1.5.1/go.mod h1:5W2xD1RspED5o8YsWQXVCued0rvSQ+mT+I5cxcmMvtA="
	"github.com/zenazn/goji v0.9.0/go.mod h1:7S9M489iMyHBNxwZnk9/EHS098H4/F6TATF2mIxtB1Q="
	"go.uber.org/atomic v1.3.2/go.mod h1:gD2HeocX3+yG+ygLZcrzQJaqmWj9AIm7n08wl/qW/PE="
	"go.uber.org/atomic v1.4.0/go.mod h1:gD2HeocX3+yG+ygLZcrzQJaqmWj9AIm7n08wl/qW/PE="
	"go.uber.org/atomic v1.6.0/go.mod h1:sABNBOSYdrvTF6hTgEIbc7YasKWGhgEQZyfxyTvoXHQ="
	"go.uber.org/multierr v1.1.0/go.mod h1:wR5kodmAFQ0UK8QlbwjlSNy0Z68gJhDJUG5sjR94q/0="
	"go.uber.org/multierr v1.5.0/go.mod h1:FeouvMocqHpRaaGuG9EjoKcStLC43Zu/fmqdUMPcKYU="
	"go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee/go.mod h1:vJERXedbb3MVM5f9Ejo0C68/HhF8uaILCdgjnY+goOA="
	"go.uber.org/zap v1.9.1/go.mod h1:vwi/ZaCAaUcBkycHslxD9B2zi4UTXhF60s6SWpuDF0Q="
	"go.uber.org/zap v1.10.0/go.mod h1:vwi/ZaCAaUcBkycHslxD9B2zi4UTXhF60s6SWpuDF0Q="
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w="
	"golang.org/x/crypto v0.0.0-20190411191339-88737f569e3a/go.mod h1:WFFai1msRO1wXaEeE5yQxYXgSfI8pQAWXbQop6sCtWE="
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod h1:yigFU9vqHzYiE8UmvKecakEJjdnWj3jj499lnFckfCI="
	"golang.org/x/crypto v0.0.0-20190820162420-60c769a6c586/go.mod h1:yigFU9vqHzYiE8UmvKecakEJjdnWj3jj499lnFckfCI="
	"golang.org/x/crypto v0.0.0-20190911031432-227b76d455e7/go.mod h1:yigFU9vqHzYiE8UmvKecakEJjdnWj3jj499lnFckfCI="
	"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59 h1:3zb4D3T4G8jdExgVU/95+vQXfpEPiMdCaZgmGVxjNHM="
	"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59/go.mod h1:LzIPMQfyMNhhGPhUkYOs5KpL4U8rLKemX1yGLhDgUto="
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9 h1:psW17arqaxU48Z5kZ0CQnkZWQJsqcURM6tKiBApRjXI="
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod h1:LzIPMQfyMNhhGPhUkYOs5KpL4U8rLKemX1yGLhDgUto="
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod h1:6SW0HCj/g11FgYtHlgUYUwCkIfeOF89ocIRzGO/8vkc="
	"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod h1:mXi4GBBbnImb6dmsKGUJ2LatrhH/nqhxcFungHvyanc="
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg="
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg="
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod h1:z5CRVTTTmAJ677TzLLGU+0bjPO0LkuOLi4/5GtJWs/s="
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7 h1:fHDIZ2oxGnUZRN6WgWFCbYBjH9uqVPRCUVUDhs0wnbA="
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7/go.mod h1:z5CRVTTTmAJ677TzLLGU+0bjPO0LkuOLi4/5GtJWs/s="
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58 h1:8gQV6CLnAEikrhgkHFbMAEhagSSnXWGV915qUMm9mrU="
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM="
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e h1:vcxGaoTs7kV8m5Np9uUNQin4BrLOthgV7252N8V+FwY="
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM="
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY="
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY="
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY="
	"golang.org/x/sys v0.0.0-20190403152447-81d4e9dc473e/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20190813064441-fde4db37ae7a/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200428200454-593003d681fa h1:yMbJOvnfYkO1dSAviTu/ZguZWLBTXx4xE3LYrxUCCiA="
	"golang.org/x/sys v0.0.0-20200428200454-593003d681fa/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ="
	"golang.org/x/text v0.3.2 h1:tW2bmiBqwgJj/UpqtC8EpXEZVYOwU0yG4iWbprSVAcs="
	"golang.org/x/text v0.3.2/go.mod h1:bEr9sfX3Q8Zfm5fL9x+3itogRgK3+ptLWKqgva+5dAk="
	"golang.org/x/text v0.3.3 h1:cokOdA+Jmi5PJGXLlLllQSgYigAEfHXJAERHVMaCc2k="
	"golang.org/x/text v0.3.3/go.mod h1:5Zoc/QRtKVWzQhOtBMvqHzDpF6irO9z98xDceosuGiQ="
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ="
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod h1:LCzVGOaR6xXOjkQ3onu1FJEFr0SW1gC7cKk1uF8kGRs="
	"golang.org/x/tools v0.0.0-20190425163242-31fd60d6bfdc/go.mod h1:RgjU9mgBXZiqYHBnxXauZ1Gv1EHHAz9KjViQ78xBX0Q="
	"golang.org/x/tools v0.0.0-20190621195816-6e04913cbbac/go.mod h1:/rFqwRUd4F7ZHNgwSSTFct+R/Kf4OFW1sUzUTQQTgfc="
	"golang.org/x/tools v0.0.0-20190823170909-c4a336ef6a2f/go.mod h1:b+2E5dAYhXwXZwtnZ6UAqBI28+e2cm9otk0dWdXHAEo="
	"golang.org/x/tools v0.0.0-20191029041327-9cc4af7d6b2c/go.mod h1:b+2E5dAYhXwXZwtnZ6UAqBI28+e2cm9otk0dWdXHAEo="
	"golang.org/x/tools v0.0.0-20191029190741-b9c20aec41a5/go.mod h1:b+2E5dAYhXwXZwtnZ6UAqBI28+e2cm9otk0dWdXHAEo="
	"golang.org/x/xerrors v0.0.0-20190410155217-1f06c39b4373/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"golang.org/x/xerrors v0.0.0-20190513163551-3ee3066db522/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898 h1:/atklqdjdhuosWIl6AIbOeHJjicWYPqR9bpxqxYG2pA="
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543 h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4="
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1 h1:go1bK/D/BFZV2I8cIQd1NKEZ+0owSTG1fDTci4IqFcE="
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0="
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d h1:TxyelI5cVkbREznMhfzycHdkp5cLA7DpE+GKjSslYhM="
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d/go.mod h1:cuepJuh7vyXfUyUwEgHQXw849cJrilpS5NeIjOWESAw="
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod h1:Co6ibVJAznAaIkqp8huTwlJQCZ016jof/cbN4VW5Yz0="
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127 h1:qIbj1fsPNlZgppZ+VLlY7N33q108Sa+fhmuc+sWQYwY="
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod h1:Co6ibVJAznAaIkqp8huTwlJQCZ016jof/cbN4VW5Yz0="
	"gopkg.in/errgo.v2 v2.1.0/go.mod h1:hNsd1EY+bozCKY1Ytp96fpM3vjJbqLJn88ws8XvfDNI="
	"gopkg.in/inconshreveable/log15.v2 v2.0.0-20180818164646-67afb5ed74ec/go.mod h1:aPpfJ7XW+gOuirDoZ8gHhLh3kZ1B08FtV2bbmy7Jv3s="
	"gopkg.in/natefinch/npipe.v2 v2.0.0-20160621034901-c1b8fa8bdcce h1:+JknDZhAj8YMt7GC73Ei8pv4MzjDUNPHgQWJdtMAaDU="
	"gopkg.in/natefinch/npipe.v2 v2.0.0-20160621034901-c1b8fa8bdcce/go.mod h1:5AcXVHNjg+BDxry382+8OKon8SEWiKktQR07RKPsv1c="
	"gopkg.in/yaml.v2 v2.2.2/go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI="
	"gopkg.in/yaml.v2 v2.2.8 h1:obN1ZagJSUGI0Ek/LBmuj4SNLPfIny3KsKFopxRdj10="
	"gopkg.in/yaml.v2 v2.2.8/go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI="
	"honnef.co/go/tools v0.0.1-2019.2.3/go.mod h1:a3bituU0lyd329TUQxRnasdCoJDkEUEAqEt0JzvZhAg="
)
go-module_set_globals

DESCRIPTION="ZABBIX is software for monitoring of your applications, network and servers"
HOMEPAGE="https://www.zabbix.com/"
MY_P=${P/_/}
MY_PV=${PV/_/}
SRC_URI="https://cdn.zabbix.com/${PN}/sources/stable/$(ver_cut 1-2)/${P}.tar.gz
	agent2? ( ${EGO_SUM_SRC_URI} )
"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="~amd64 ~x86"
IUSE="+agent +agent2 java curl frontend ipv6 ldap libxml2 mysql openipmi oracle +postgres proxy server ssh ssl snmp sqlite odbc static"
REQUIRED_USE="|| ( agent agent2 frontend proxy server )
	proxy? ( ^^ ( mysql oracle postgres sqlite odbc ) )
	server? ( ^^ ( mysql oracle postgres odbc ) )
	static? ( !oracle !snmp )"

COMMON_DEPEND="
	curl? ( net-misc/curl )
	java? ( >=virtual/jdk-1.8:* )
	ldap? (
		=dev-libs/cyrus-sasl-2*
		net-libs/gnutls
		net-nds/openldap
	)
	libxml2? ( dev-libs/libxml2 )
	mysql? ( dev-db/mysql-connector-c )
	odbc? ( dev-db/unixODBC )
	openipmi? ( sys-libs/openipmi )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:* )
	proxy?  ( sys-libs/zlib )
	server? (
		dev-libs/libevent
		sys-libs/zlib
	)
	snmp? ( net-analyzer/net-snmp )
	sqlite? ( dev-db/sqlite )
	ssh? ( net-libs/libssh2 )
	ssl? ( dev-libs/openssl:=[-bindist] )
"

RDEPEND="${COMMON_DEPEND}
	acct-group/zabbix
	acct-user/zabbix
	java? ( >=virtual/jre-1.8:* )
	mysql? ( virtual/mysql )
	proxy? ( net-analyzer/fping[suid] )
	server? (
		app-admin/webapp-config
		dev-libs/libevent
		dev-libs/libpcre
		net-analyzer/fping[suid]
	)
	frontend? (
		app-admin/webapp-config
		dev-lang/php:*[bcmath,ctype,sockets,gd,truetype,xml,session,xmlreader,xmlwriter,nls,sysvipc,unicode]
		media-libs/gd[png]
		virtual/httpd-php:*
		mysql? ( dev-lang/php[mysqli] )
		odbc? ( dev-lang/php[odbc] )
		oracle? ( dev-lang/php[oci8-instant-client] )
		postgres? ( dev-lang/php[postgres] )
		sqlite? ( dev-lang/php[sqlite] )
	)
"
DEPEND="${COMMON_DEPEND}
	static? (
		curl? ( net-misc/curl[static-libs] )
		ldap? (
			=dev-libs/cyrus-sasl-2*[static-libs]
			net-libs/gnutls[static-libs]
			net-nds/openldap[static-libs]
		)
		libxml2? ( dev-libs/libxml2[static-libs] )
		mysql? ( dev-db/mysql-connector-c[static-libs] )
		odbc? ( dev-db/unixODBC[static-libs] )
		postgres? ( dev-db/postgresql:*[static-libs] )
		sqlite? ( dev-db/sqlite[static-libs] )
		ssh? ( net-libs/libssh2 )
	)
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.18-modulepathfix.patch"
	"${FILESDIR}/${PN}-3.0.30-security-disable-PidFile.patch"
)

S=${WORKDIR}/${MY_P}

ZABBIXJAVA_BASE="opt/zabbix_java"

pkg_setup() {
	if use oracle; then
		if [ -z "${ORACLE_HOME}" ]; then
			eerror
			eerror "The environment variable ORACLE_HOME must be set"
			eerror "and point to the correct location."
			eerror "It looks like you don't have Oracle installed."
			eerror
			die "Environment variable ORACLE_HOME is not set"
		fi
		if has_version 'dev-db/oracle-instantclient-basic'; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "dev-db/oracle-instantclient* is NOT sufficient."
			ewarn
		fi
	fi

	if use frontend; then
		webapp_pkg_setup
	fi

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
}

src_configure() {
	econf \
		$(use_enable agent) \
		$(use_enable agent2) \
		$(use_enable ipv6) \
		$(use_enable java) \
		$(use_enable proxy) \
		$(use_enable server) \
		$(use_enable static) \
		$(use_with curl libcurl) \
		$(use_with ldap) \
		$(use_with libxml2) \
		$(use_with mysql) \
		$(use_with odbc unixodbc) \
		$(use_with openipmi openipmi) \
		$(use_with oracle) \
		$(use_with postgres postgresql) \
		$(use_with snmp net-snmp) \
		$(use_with sqlite sqlite3) \
		$(use_with ssh ssh2) \
		$(use_with ssl openssl)
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
	fi
}

src_install() {
	local dirs=(
		/etc/zabbix
		/var/lib/zabbix
		/var/lib/zabbix/home
		/var/lib/zabbix/scripts
		/var/lib/zabbix/alertscripts
		/var/lib/zabbix/externalscripts
		/var/log/zabbix
	)

	for dir in "${dirs[@]}"; do
		dodir "${dir}"
		keepdir "${dir}"
	done

	if use server; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_server.conf
		fperms 0640 /etc/zabbix/zabbix_server.conf
		fowners root:zabbix /etc/zabbix/zabbix_server.conf

		newinitd "${FILESDIR}"/zabbix-server.init zabbix-server

		dosbin src/zabbix_server/zabbix_server

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-server.service
		systemd_newtmpfilesd "${FILESDIR}"/zabbix-server.tmpfiles zabbix-server.conf
	fi

	if use proxy; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_proxy.conf
		fperms 0640 /etc/zabbix/zabbix_proxy.conf
		fowners root:zabbix /etc/zabbix/zabbix_proxy.conf

		newinitd "${FILESDIR}"/zabbix-proxy.init zabbix-proxy

		dosbin src/zabbix_proxy/zabbix_proxy

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-proxy.service
		systemd_newtmpfilesd "${FILESDIR}"/zabbix-proxy.tmpfiles zabbix-proxy.conf
	fi

	if use agent; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_agentd.conf
		fperms 0640 /etc/zabbix/zabbix_agentd.conf
		fowners root:zabbix /etc/zabbix/zabbix_agentd.conf

		newinitd "${FILESDIR}"/zabbix-agentd.init zabbix-agentd

		dosbin src/zabbix_agent/zabbix_agentd
		dobin \
			src/zabbix_sender/zabbix_sender \
			src/zabbix_get/zabbix_get

		systemd_dounit "${FILESDIR}"/zabbix-agentd.service
		systemd_newtmpfilesd "${FILESDIR}"/zabbix-agentd.tmpfiles zabbix-agentd.conf
	fi

	if use agent2; then
		insinto /etc/zabbix
		doins "${S}"/src/go/conf/zabbix_agent2.conf
		fperms 0640 /etc/zabbix/zabbix_agent2.conf
		fowners root:zabbix /etc/zabbix/zabbix_agent2.conf

		newinitd "${FILESDIR}"/zabbix-agent2.init zabbix-agent2

		dosbin src/go/bin/zabbix_agent2

		systemd_dounit "${FILESDIR}"/zabbix-agent2.service
		systemd_newtmpfilesd "${FILESDIR}"/zabbix-agent2.tmpfiles zabbix-agent2.conf
	fi

	fowners root:zabbix /etc/zabbix
	fowners zabbix:zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix
	fperms 0750 \
		/etc/zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix

	dodoc README INSTALL NEWS ChangeLog \
		conf/zabbix_agentd.conf \
		conf/zabbix_proxy.conf \
		conf/zabbix_agentd/userparameter_examples.conf \
		conf/zabbix_agentd/userparameter_mysql.conf \
		conf/zabbix_server.conf

	if use frontend; then
		webapp_src_preinst
		cp -R ui/* "${D}/${MY_HTDOCSDIR}"
		webapp_configfile \
			"${MY_HTDOCSDIR}"/include/db.inc.php \
			"${MY_HTDOCSDIR}"/include/config.inc.php
		webapp_src_install
	fi

	if use java; then
		dodir \
			/${ZABBIXJAVA_BASE} \
			/${ZABBIXJAVA_BASE}/bin \
			/${ZABBIXJAVA_BASE}/lib
		keepdir /${ZABBIXJAVA_BASE}
		exeinto /${ZABBIXJAVA_BASE}/bin
		doexe src/zabbix_java/bin/zabbix-java-gateway-${MY_PV}.jar
		exeinto /${ZABBIXJAVA_BASE}/lib
		doexe \
			src/zabbix_java/lib/logback-classic-0.9.27.jar \
			src/zabbix_java/lib/logback-console.xml \
			src/zabbix_java/lib/logback-core-0.9.27.jar \
			src/zabbix_java/lib/logback.xml \
			src/zabbix_java/lib/android-json-4.3_r3.1.jar \
			src/zabbix_java/lib/slf4j-api-1.6.1.jar
		newinitd "${FILESDIR}"/zabbix-jmx-proxy.init zabbix-jmx-proxy
		newconfd "${FILESDIR}"/zabbix-jmx-proxy.conf zabbix-jmx-proxy
	fi
}

pkg_postinst() {
	if use server || use proxy ; then
		elog
		elog "You may need to configure your database for Zabbix"
		elog "if you have not already done so."
		elog

		zabbix_homedir=$(egethome zabbix)
		if [ -n "${zabbix_homedir}" ] && \
		   [ "${zabbix_homedir}" != "/var/lib/zabbix/home" ]; then
			ewarn
			ewarn "The user 'zabbix' should have his homedir changed"
			ewarn "to /var/lib/zabbix/home if you want to use"
			ewarn "custom alert scripts."
			ewarn
			ewarn "A real homedir might be needed for configfiles"
			ewarn "for custom alert scripts."
			ewarn
			ewarn "To change the homedir use:"
			ewarn "  usermod -d /var/lib/zabbix/home zabbix"
			ewarn
		fi
	fi

	if use server; then
		elog
		elog "For distributed monitoring you have to run:"
		elog
		elog "zabbix_server -n <nodeid>"
		elog
		elog "This will convert database data for use with Node ID"
		elog "and also adds a local node."
		elog
	fi

	elog "--"
	elog
	elog "You may need to add these lines to /etc/services:"
	elog
	elog "zabbix-agent     10050/tcp Zabbix Agent"
	elog "zabbix-agent     10050/udp Zabbix Agent"
	elog "zabbix-trapper   10051/tcp Zabbix Trapper"
	elog "zabbix-trapper   10051/udp Zabbix Trapper"
	elog

	if use server || use proxy ; then
		# check for fping
		fping_perms=$(stat -c %a /usr/sbin/fping 2>/dev/null)
		case "${fping_perms}" in
			4[157][157][157])
				;;
			*)
				ewarn
				ewarn "If you want to use the checks 'icmpping' and 'icmppingsec',"
				ewarn "you have to make /usr/sbin/fping setuid root and executable"
				ewarn "by everyone. Run the following command to fix it:"
				ewarn
				ewarn "  chmod u=rwsx,g=rx,o=rx /usr/sbin/fping"
				ewarn
				ewarn "Please be aware that this might impose a security risk,"
				ewarn "depending on the code quality of fping."
				ewarn
				;;
		esac
	fi
}

pkg_prerm() {
	(use frontend || use server) && webapp_pkg_prerm
}
