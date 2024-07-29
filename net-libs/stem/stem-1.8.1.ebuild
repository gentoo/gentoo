# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Stem is a Python controller library for Tor"
HOMEPAGE="https://stem.torproject.org"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/pyflakes[${PYTHON_USEDEP}]
	net-vpn/tor )"

RDEPEND="net-vpn/tor"

DOCS=( docs/{_static,_templates,api,tutorials,{api,change_log,contents,download,faq,index,tutorials}.rst} )

src_prepare() {
	default

	# https://bugzilla.redhat.com/2021902
	eapply "${FILESDIR}/1.8.0-replace-all-usages-of-inspect.getargspec.patch"

	# https://github.com/torproject/stem/issues/53
	eapply "${FILESDIR}/${PV}-Add-an-exclude-test-argument.patch"

	# https://github.com/torproject/stem/issues/56
	sed -i '/MOCK_VERSION/d' run_tests.py || die
}

python_test() {
	# Disable failing test
	${PYTHON} run_tests.py --all --target RUN_ALL \
		--exclude-test test.integ.installation.TestInstallation.test_install \
		--exclude-test test.integ.util.system.TestSystem.test_expand_path \
		--exclude-test test.integ.control.controller.TestController.test_get_listeners \
		--exclude-test test.integ.control.controller.TestController.test_get_ports \
		--exclude-test test.integ.control.controller.TestController.test_getinfo_freshrelaydescs \
		|| die

}
