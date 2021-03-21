# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="A unit test framework for C"
HOMEPAGE="https://libcheck.github.io/check/"
SRC_URI="https://github.com/libcheck/check/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc subunit test"

# Tests seem to timeout on ppc* systems, #736661
RESTRICT="ppc? ( test )
	ppc64? ( test )
	!test? ( test )"

RDEPEND="subunit? ( dev-python/subunit[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"
BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/check-0.14.0-r2-disable-automagic-dep.patch
	"${FILESDIR}"/${P}-Fix-pkgconfig-file-s-libdir-value.patch
)

#src_prepare() {
#	cmake_src_prepare
#}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCHECK_ENABLE_SUBUNIT=$(usex subunit ON OFF)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if use doc && multilib_is_native_abi; then
		cd "${S}"/doc/ || die "Failed to switch directories."
		doxygen "." || die "Failed to run doxygen to generate docs."
	fi
}

multilib_src_install_all() {
	use doc && local HTML_DOCS=( "${S}"/doc/html/. )
	einstalldocs

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
