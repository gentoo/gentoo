# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Lib/tool to communicate with AVM FRITZ! devices using TR-064 protocol over UPnP"
HOMEPAGE="
	https://github.com/kbr/fritzconnection/
	https://pypi.org/project/fritzconnection/
"

LICENSE="MIT"
SLOT="0"
IUSE="qrcode"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/kbr/fritzconnection"
	inherit git-r3
else
	SRC_URI="
		https://github.com/kbr/fritzconnection/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

RDEPEND="
	>=dev-python/requests-2.22[${PYTHON_USEDEP}]
	qrcode? (
		dev-python/segno[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# flaky (relies on time.sleep(0.01) magically being sufficient)
		fritzconnection/tests/test_fritzmonitor.py::test_terminate_thread_on_failed_reconnection
	)

	if has_version "dev-python/segno[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			# requires "QR Code detection" support in media-libs/opencv
			# https://bugs.gentoo.org/917121
			fritzconnection/tests/test_fritzwlan.py::test_get_wifi_qr_code
			fritzconnection/tests/test_fritzwlan.py::test_helper_functions
			fritzconnection/tests/test_fritzwlan.py::test_tools
		)
	fi

	# "routertest" marks tests against live hardware
	epytest -m "not routertest"
}
