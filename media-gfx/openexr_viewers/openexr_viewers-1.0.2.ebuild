# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils flag-o-matic

DESCRIPTION="OpenEXR Viewers"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"
HOMEPAGE="http://openexr.com/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="opengl video_cards_nvidia"

RDEPEND=">=media-libs/ilmbase-1.0.2
	>=media-libs/openexr-1.7.0
	media-libs/ctl
	media-libs/openexr_ctl
	opengl? ( virtual/opengl
		x11-libs/fltk:1[opengl]
		video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit ) )
	!<media-libs/openexr-1.5.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nvidia-automagic.patch \
		"${FILESDIR}"/${PN}-1.0.1-gcc43.patch \
		"${FILESDIR}"/${PN}-1.0.1-gcc44.patch

	eautoreconf
}

src_configure() {
	local myconf

	if use video_cards_nvidia; then
		myconf="--with-cg-prefix=/opt/nvidia-cg-toolkit"
		append-flags $(no-as-needed) # binary-only libCg is not properly linked
	fi

	econf \
		--disable-dependency-tracking \
		$(use_enable video_cards_nvidia nvidia) \
		$(use_with opengl fltk-config /usr/bin/fltk-config) \
		${myconf}
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}/pdf" \
		install || die

	dodoc AUTHORS ChangeLog NEWS README
}
