# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7})

inherit distutils-r1

MY_PN=OctoPrint
MY_PV=${PV/_/}
S=${WORKDIR}/${MY_PN}-${MY_PV}

DESCRIPTION="the snappy web interface for your 3D printer"
HOMEPAGE="https://octoprint.org/"
LICENSE="AGPL-3"
SRC_URI="https://github.com/foosel/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND="
	acct-user/octoprint
	acct-group/octoprint
	dev-python/pip
	>=dev-python/flask-0.12
	<dev-python/flask-0.13
	>=dev-python/jinja-2.8.1
	<dev-python/jinja-2.9
	~www-servers/tornado-4.5.3
	dev-python/regex
	>=dev-python/flask-login-0.4.1
	<dev-python/flask-login-0.5
	>=dev-python/flask-babel-0.12
	<dev-python/flask-babel-0.13
	>=dev-python/flask-assets-0.12
	<dev-python/flask-assets-0.13
	>=dev-python/blinker-1.4
	<dev-python/blinker-1.5
	>=dev-python/werkzeug-0.16
	<dev-python/werkzeug-0.17
	>=dev-python/cachelib-0.1
	<dev-python/cachelib-0.2
	>=dev-python/pyyaml-5.1
	<dev-python/pyyaml-6
	>=dev-python/markdown-3.1
	<dev-python/markdown-3.2
	>=dev-python/pyserial-3.4
	<dev-python/pyserial-3.5
	>=dev-python/netaddr-0.7.19
	<dev-python/netaddr-0.8
	>=dev-python/watchdog-0.9.0
	<dev-python/watchdog-0.10
	~dev-python/sarge-0.1.5
	>=dev-python/netifaces-0.10.9
	<dev-python/netifaces-0.11
	>=dev-python/pylru-1.2
	<dev-python/pylru-1.3
	>=dev-python/rsa-4.0
	<dev-python/rsa-5
	>=dev-python/pkginfo-1.5.0.1
	<dev-python/pkginfo-1.6
	>=dev-python/requests-2.22.0
	<dev-python/requests-3
	>=dev-python/semantic_version-2.8
	<dev-python/semantic_version-2.9
	>=dev-python/psutil-5.6.5
	<dev-python/psutil-5.7
	>=dev-python/click-7
	<dev-python/click-8
	>=dev-python/awesome-slugify-1.6.5
	<dev-python/awesome-slugify-1.7
	>=dev-python/feedparser-5.2.1
	<dev-python/feedparser-5.3
	>=dev-python/future-0.18.2
	<dev-python/future-0.19
	>=dev-python/websocket-client-0.56
	<dev-python/websocket-client-0.57
	>=dev-python/wrapt-1.11.2
	<dev-python/wrapt-1.12
	>=dev-python/emoji-0.5.4
	<dev-python/emoji-0.6
	>=dev-python/frozendict-1.2
	<dev-python/frozendict-1.3
	~dev-python/sentry-sdk-0.13.2
	>=dev-python/filetype-1.0.5
	<dev-python/filetype-2
"

src_install()
{
	distutils-r1_src_install
	newinitd "$FILESDIR/$PN.initd" "$PN"
	newconfd "$FILESDIR/$PN.confd" "$PN"
}
