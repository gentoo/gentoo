# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libast/libast-9999.ebuild,v 1.12 2015/01/28 22:21:05 mgorny Exp $

#ECVS_SERVER="cvs.sourceforge.net:/cvsroot/enlightenment"
ECVS_SERVER="anoncvs.enlightenment.org:/var/cvs/e"
ECVS_MODULE="eterm/libast"
inherit eutils cvs autotools

DESCRIPTION="LIBrary of Assorted Spiffy Things"
HOMEPAGE="http://www.eterm.org/download/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="imlib cpu_flags_x86_mmx pcre"

RDEPEND="!sci-astronomy/ast
	x11-libs/libXt
	x11-proto/xproto
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	=media-libs/freetype-2*
	imlib? ( media-libs/imlib2 )
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${ECVS_MODULE}

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	eautoreconf
}

src_compile() {
	local myregexp="posix"
	use pcre && myregexp="pcre"
	econf \
		$(use_with imlib) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		--with-regexp=${myregexp} \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README DESIGN ChangeLog
}
