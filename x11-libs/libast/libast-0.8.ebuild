# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="LIBrary of Assorted Spiffy Things"
HOMEPAGE="http://www.eterm.org/download/"
SRC_URI="https://github.com/mej/libast/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="imlib cpu_flags_x86_mmx pcre"

RDEPEND="
	!sci-astronomy/ast
	x11-base/xorg-proto
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	media-libs/freetype
	imlib? ( media-libs/imlib2 )
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_with imlib) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		--with-regexp=$(usex pcre pcre posix)
}

src_install() {
	default

	dodoc DESIGN

	find "${ED}" -name '*.la' -delete || die
}
