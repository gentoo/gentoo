# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 eutils user

DESCRIPTION="Plugin based XMPP chatbot designed to be easily deployable, extensible and maintainable"
HOMEPAGE="https://gbin.github.com/err/"

SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="irc qt4 +plugins"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyfire[${PYTHON_USEDEP}]
	dev-python/python-daemon[${PYTHON_USEDEP}]
	dev-python/xmpppy
	dev-python/yapsy[${PYTHON_USEDEP}]
	irc? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/twisted-core[${PYTHON_USEDEP}]
		dev-python/twisted-words[${PYTHON_USEDEP}]
	)
	qt4? ( dev-python/pyside[${PYTHON_USEDEP},X,webkit] )
	plugins? ( dev-vcs/git )"

# Testsuite is broken since 1.6.3
RESTRICT="test"

# NOTES:
# 1. It has bundled libs - for example exrex(see 'errbot/bundled' subfolder)
# 2. Need to add PYTHON_USEDEP to remaining dev-python/ deps
# 3. Support for BOT_SENTRY option is missing, cause
#    we do not have apropriate packages in portage yet
# 4. Internal web server is broken(dunno why :-()

pkg_setup() {
	ebegin "Creating err group and user"
	enewgroup 'err'
	enewuser 'err' -1 -1 -1 'err'
	eend ${?}
}

python_prepare_all() {
	# Remove configparser and config from requirements as they are NOT needed
	sed -i \
		-e "/install_requires/s/'configparser', //" \
		-e "/install_requires/s/, 'config'//" \
		setup.py || die

	# Tests are broken and should not be installed
	rm -r tests || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}"/errd.initd errd
	newconfd "${FILESDIR}"/errd.confd errd

	dodir /etc/${PN}
	dodir /var/lib/${PN}
	keepdir /var/log/${PN}
	fowners -R err:err /var/lib/${PN}
	fowners -R err:err /var/log/${PN}

	insinto /etc/${PN}
	newins errbot/config-template.py config.py
}

python_install() {
	distutils-r1_python_install

	# Upstream requires images to be in site-packages directory,
	# but does not install them at all!
	if use qt4; then
		local python_moduleroot=errbot
		python_domodule errbot/*.svg
	fi
}
