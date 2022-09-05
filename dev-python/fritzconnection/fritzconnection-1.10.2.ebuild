# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Lib/tool to communicate with AVM FRITZ! devices using TR-064 protocol over UPnP"
HOMEPAGE="
	https://github.com/kbr/fritzconnection/
	https://pypi.org/project/fritzconnection/
"

LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/kbr/fritzconnection"
	inherit git-r3
else
	SRC_URI="
		https://github.com/kbr/fritzconnection/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-python/requests-2.22[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# flaky (relies on time.sleep(0.01) magically being sufficient)
	fritzconnection/tests/test_fritzmonitor.py::test_terminate_thread_on_failed_reconnection
)

src_prepare() {
	# upstream is pinning for py3.6 compat x_x
	sed -i -e 's:,<[0-9.]*::' setup.py || die
	distutils-r1_src_prepare
}
