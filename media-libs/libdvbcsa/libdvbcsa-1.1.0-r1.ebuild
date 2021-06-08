# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Free implementation of the DVB Common Scrambling Algorithm - DVB/CSA"
HOMEPAGE="https://www.videolan.org/developers/libdvbcsa.html"
SRC_URI="https://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="cpu_flags_ppc_altivec cpu_flags_x86_mmx cpu_flags_x86_sse2 debug"

# https://github.com/buildroot/buildroot/blob/master/package/libdvbcsa/
PATCHES=( "${FILESDIR}/altivec.patch" )

src_configure() {
	use cpu_flags_ppc_altivec && append-cflags '-flax-vector-conversions' # needed for altivec.patch
	local myeconfargs=(
		--disable-static
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable debug)
	)

	# Enabling MMX makes the configure script ignore SSE2.
	if use cpu_flags_x86_sse2; then
		myeconfargs+=(
			--disable-mmx
			--enable-sse2
		)
	else
		myeconfargs+=(
			$(use_enable cpu_flags_x86_mmx mmx)
			--disable-sse2
		)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
