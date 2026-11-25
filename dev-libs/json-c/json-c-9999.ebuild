# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/json-c/json-c.git"
	inherit git-r3
else
	# https://github.com/json-c/json-c/wiki#obtain-sources
	SRC_URI="https://s3.amazonaws.com/json-c_releases/releases/${P}.tar.gz"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
fi

LICENSE="MIT"
# .1 is a fudge factor for 0.18 fixing compat w/ 0.16, drop on next
# SONAME change.
SLOT="0/5.1"
IUSE="cpu_flags_x86_rdrand static-libs test threads"
RESTRICT="!test? ( test )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/json-c/config.h
)

PATCHES=(
	"${FILESDIR}"/${PN}-0.19-meson.patch
	"${FILESDIR}"/${PN}-0.19-meson-conditionally-build-tests-with-an-option-not-b.patch
	"${FILESDIR}"/${PN}-0.19-meson-wire-up-disable_extra_libs-option.patch
	"${FILESDIR}"/${PN}-0.19-meson-fix-version-numbers.patch
	"${FILESDIR}"/${PN}-0.19-meson-fix-pkgconfig-file.patch
)

multilib_src_configure() {
	# Tests use Valgrind automagically otherwise (bug #927027)
	export USE_VALGRIND=0

	local emesonargs=(
		# apps are not installed, so disable w/o tests.
		# https://github.com/json-c/json-c/blob/json-c-0.17-20230812/apps/mesonLists.txt#L119...L121
		$(meson_use test build_apps)
		$(meson_use test build_tests)
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		-Dextra_libs=disabled
		$(meson_use cpu_flags_x86_rdrand enable_rdrand)
		$(meson_use threads enable_threading)
	)

	meson_src_configure
}
