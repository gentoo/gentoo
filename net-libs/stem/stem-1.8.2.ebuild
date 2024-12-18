# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Stem is a Python controller library for Tor"
HOMEPAGE="https://stem.torproject.org"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="net-vpn/tor"
BDEPEND="test? ( net-vpn/tor )"

DOCS=( docs/{_static,_templates,api,tutorials,{api,change_log,contents,download,faq,index,tutorials}.rst} )

PATCHES=(
	# https://github.com/torproject/stem/issues/53
	"${FILESDIR}"/1.8.1-Add-an-exclude-test-argument.patch
)

python_prepare_all() {
	# https://github.com/torproject/stem/issues/56
	sed -i '/MOCK_VERSION/d' run_tests.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local skipped_tests=(
		--exclude-test test.integ.installation.TestInstallation.test_install
		--exclude-test test.integ.util.system.TestSystem.test_expand_path
		--exclude-test test.integ.control.controller.TestController.test_get_listeners
		--exclude-test test.integ.control.controller.TestController.test_get_ports
		--exclude-test test.integ.control.controller.TestController.test_getinfo_freshrelaydescs
		# confused by exception text change for JSON parsing
		--exclude-test test.unit.descriptor.collector.TestCollector.test_index_malformed_json
	)

	# We use --unit --integ to avoid the static/style/lint checks.
	${EPYTHON} run_tests.py --verbose --unit --integ "${skipped_tests[@]}" || die "Tests failed with ${EPYTHON}"
}
