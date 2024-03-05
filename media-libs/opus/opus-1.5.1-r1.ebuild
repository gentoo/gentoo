# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit flag-o-matic meson-multilib python-any-r1

DESCRIPTION="Open codec for interactive speech and music transmission over the Internet"
HOMEPAGE="https://opus-codec.org/"
SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="custom-modes debug doc hardened static-libs test ${INTRINSIC_FLAGS}"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
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

		# These all have runtime toggles too, per https://opus-codec.org/demo/opus-1.5/
		-Denable-deep-plc=true
		-Denable-dred=true
		-Denable-osce=true

		$(meson_use custom-modes)
		$(meson_feature test tests)
		$(meson_use debug assertions)
		$(meson_use hardened hardening)

		$(meson_native_use_feature doc docs)

		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
	)

	# Disable intrinsics if no flags are enabled (bug #752069)
	# bug #752069
	# TODO: What is -Dasm for?
	local i
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
