# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

MY_P=certifi-system-store-${PV}
DESCRIPTION="A certifi hack to use system trust store on Linux/FreeBSD"
HOMEPAGE="
	https://github.com/tiran/certifi-system-store/
	https://pypi.org/project/certifi-system-store/"
SRC_URI="
	https://github.com/tiran/certifi-system-store/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="app-misc/ca-certificates"

PATCHES=(
	"${FILESDIR}"/${PN}-3021.3.16-setuptools.patch
)

EPYTEST_IGNORE=(
	# requires Internet
	tests/test_requests.py
)

distutils_enable_tests --install pytest

src_prepare() {
	sed -i -e "s^/etc^${EPREFIX}/etc^" src/certifi/core.py || die
	distutils-r1_src_prepare
}

symlink_info() {
	pushd "${1}" >/dev/null || die
	local egginfo=( certifi_system_store*.egg-info )
	[[ -d ${egginfo} ]] || die
	ln -v -s "${egginfo}" "${egginfo/_system_store}" || die
	popd >/dev/null || die
}

python_test() {
	distutils_install_for_testing
	symlink_info "${TEST_DIR}"/lib
	epytest
}

python_install() {
	distutils-r1_python_install
	symlink_info "${D}$(python_get_sitedir)"
}
