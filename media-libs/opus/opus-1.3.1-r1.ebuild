# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Open codec for interactive speech and music transmission over the Internet"
HOMEPAGE="https://opus-codec.org/"
SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="custom-modes doc static-libs ${INTRINSIC_FLAGS}"

DEPEND="doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && myeconfargs+=( --enable-intrinsics )
	done
	if is-flagq -ffast-math || is-flagq -Ofast; then
		myeconfargs+=( "--enable-float-approx" )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -name "*.la" -delete || die
}
