# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Open codec for interactive speech and music transmission over the Internet"
HOMEPAGE="https://opus-codec.org/"
SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="custom-modes doc static-libs ${INTRINSIC_FLAGS}"

BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-libdir-macro.patch
)

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable doc)
		$(use_enable static-libs static)
	)

	local i
	# We want to disable intrinsics if no flags are enabled
	# (This is a fun Bash construct to do that!)
	# bug #752069
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && myeconfargs+=( --enable-intrinsics ) && break
	done || myeconfargs+=( --disable-intrinsics )

	if is-flagq -ffast-math || is-flagq -Ofast; then
		myeconfargs+=( --enable-float-approx )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
}
