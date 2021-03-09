# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Python module for downloading files"
HOMEPAGE="http://urlgrabber.baseurl.org https://github.com/rpm-software-management/urlgrabber"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PN}-${PV//./-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-${PV//./-}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
RESTRICT="test"

RDEPEND="
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/six[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-skip-test_range.patch"
	"${FILESDIR}/${P}-test-mirror-set-thread-daemon.patch"
)

python_test() {
	# Entire testsuite relies on connecting to the i'net, added for reference
	URLGRABBER_EXT_DOWN="${S}/scripts/urlgrabber-ext-down" \
	PYTHON_PATH="${S}" \
	"${PYTHON}" test/runtests.py -v 2 || die "tests failed under ${EPYTHON}"
}
