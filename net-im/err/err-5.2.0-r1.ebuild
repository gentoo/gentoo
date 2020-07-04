# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

MY_PN="errbot"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1 user

DESCRIPTION="Multiprotocol chatbot designed to be easily deployable and maintainable"
HOMEPAGE="http://errbot.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="irc +xmpp"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/ansi[${PYTHON_USEDEP}]
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/daemonize[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/webtest[${PYTHON_USEDEP}]
	dev-python/yapsy[${PYTHON_USEDEP}]
	irc? (
		dev-python/irc[${PYTHON_USEDEP}]
	)
	xmpp? (
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/sleekxmpp[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_P}"

# NOTES:
# 1. Support for BOT_SENTRY option is missing, cause
#    we do not have apropriate packages in portage yet
# 2. Currently only XMPP is supported(IRC still untested)
# 3. Internal web server is temporarily removed (rocket-err from requires.txt)
# 4. pygments-markdown-lexer dependency(needed only for debugging?) is temporarily removed (pygments-markdown-lexer from requires.txt)

pkg_setup() {
	ebegin "Creating err group and user"
	enewgroup 'err'
	enewuser 'err' -1 -1 -1 'err'
	eend ${?}
}

python_prepare_all() {
	sed -i \
		-e '/rocket-errbot/d' \
		-e 's/dnspython3/dnspython/' \
		-e '/pygments-markdown-lexer/d' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}"/errd.initd.2 errd
	newconfd "${FILESDIR}"/errd.confd errd

	dodir /etc/${PN}
	keepdir /var/lib/${PN}
	keepdir /var/log/${PN}
	fowners -R err:err /var/lib/${PN}
	fowners -R err:err /var/log/${PN}

	insinto /etc/${PN}
	newins errbot/config-template.py config.py
}
