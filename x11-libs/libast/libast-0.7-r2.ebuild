# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="LIBrary of Assorted Spiffy Things"
HOMEPAGE="http://www.eterm.org/download/"
SRC_URI="http://www.eterm.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
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

DOCS=( README DESIGN ChangeLog )

src_prepare() {
	default
	local myregexp="posix"
	use pcre && myregexp="pcre"
	econf \
		$(use_with imlib) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		--with-regexp="${myregexp}"
}

src_install() {
	default
	emake DESTDIR="${D}" install
}
