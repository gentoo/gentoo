# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
CMAKE_ECLASS=cmake
inherit cmake-multilib python-single-r1

DESCRIPTION="A tool to test PAM applications and PAM modules"
HOMEPAGE="https://cwrap.org/pam_wrapper.html"
SRC_URI="https://www.samba.org/ftp/pub/cwrap/${P}.tar.gz
	https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-libs/pam:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka[${MULTILIB_USEDEP}] )"

multilib_src_configure() {
	local libpam="${EPREFIX}"
	multilib_is_native_abi || libpam+="/usr"
	libpam+="/$(get_libdir)/libpam.so.0"

	local mycmakeargs=(
		-DPAM_LIBRARY="${libpam}"
		-DUNIT_TESTING=$(usex test)
		-DPYTHON2_LIBRARY="/dev/null" # Disabled
		-DPYTHON3_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON3_SITELIB="$(python_get_sitedir)"
	)
	cmake_src_configure
}
