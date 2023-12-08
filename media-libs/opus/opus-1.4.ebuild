# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit flag-o-matic meson-multilib python-any-r1

DESCRIPTION="Open codec for interactive speech and music transmission over the Internet"
HOMEPAGE="https://opus-codec.org/"
SRC_URI="https://github.com/xiph/opus/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="custom-modes debug doc hardened static-libs test ${INTRINSIC_FLAGS}"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-libdir-macro.patch
	"${FILESDIR}"/${PN}-1.4-arm64-neon.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)

		$(meson_use custom-modes)
		$(meson_feature test tests)
		$(meson_use debug assertions)
		$(meson_use hardened hardening)

		$(meson_native_use_feature doc docs)

		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
	)

	local i
	# We want to disable intrinsics if no flags are enabled
	# (This is a fun Bash construct to do that!)
	# bug #752069
	# TODO: What is -Dasm for?
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && emesonargs+=( -Dintrinsics=enabled ) && break
	done || emesonargs+=( -Dintrinsics=disabled )

	if is-flagq -ffast-math || is-flagq -Ofast ; then
		emesonargs+=( -Dfloat-approx=true )
	fi

	meson_src_configure
}

multilib_src_test() {
	meson_src_test --timeout-multiplier=2
}
