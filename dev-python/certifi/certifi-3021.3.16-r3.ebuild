# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

MY_P=certifi-system-store-${PV}
DESCRIPTION="A certifi hack to use system trust store on Linux/FreeBSD"
HOMEPAGE="
	https://github.com/tiran/certifi-system-store/
	https://pypi.org/project/certifi-system-store/
"
SRC_URI="
	https://github.com/tiran/certifi-system-store/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-misc/ca-certificates
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-use-importlib.patch
)

EPYTEST_IGNORE=(
	# requires Internet
	tests/test_requests.py
)

distutils_enable_tests pytest

src_prepare() {
	sed -i -e "s^/etc^${EPREFIX}/etc^" src/certifi/core.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	local distinfo=( certifi_system_store*.dist-info )
	[[ -d ${distinfo} ]] || die
	ln -v -s "${distinfo}" "${distinfo/_system_store}" || die
}
