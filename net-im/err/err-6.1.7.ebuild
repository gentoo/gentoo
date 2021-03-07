# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

MY_PN="errbot"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Multiprotocol chatbot designed to be easily deployable and maintainable"
HOMEPAGE="https://errbot.readthedocs.io/en/latest/"
SRC_URI="https://github.com/errbotio/errbot/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64"
LICENSE="GPL-3"
SLOT="0"
IUSE="irc +xmpp"

DEPEND="
	acct-group/err
	acct-user/err"
RDEPEND="${DEPEND}
	dev-python/ansi[${PYTHON_USEDEP}]
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/daemonize[${PYTHON_USEDEP}]
	dev-python/deepmerge[${PYTHON_USEDEP}]
	dev-python/dulwich[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/webtest[${PYTHON_USEDEP}]
	irc? (
		dev-python/irc[${PYTHON_USEDEP}]
	)
	xmpp? (
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/slixmpp[${PYTHON_USEDEP}]
	)"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/pygments-markdown-lexer/d' setup.py || die

	# NameError: name 'slack' is not defined
	rm tests/backend_tests/slack_test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		--deselect tests/commands_test.py::test_plugin_cycle
		--deselect tests/commands_test.py::test_broken_plugin
		--deselect tests/commands_test.py::test_backup
		--deselect tests/plugin_management_test.py::test_check_dependencies_requi
	)

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
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
