# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic autotools

DESCRIPTION="Mark commercial Breaks in VDR records"
HOMEPAGE="http://noad.heliohost.org/"
SRC_URI="http://noad.heliohost.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ffmpeg imagemagick"

DEPEND="media-libs/libmpeg2
	ffmpeg? ( >=virtual/ffmpeg-0.4.8 )
	imagemagick? ( >=media-gfx/imagemagick-6.2.4.2-r1 )
	!media-plugins/vdr-markad"
RDEPEND="${DEPEND}"

src_prepare() {

	epatch "${FILESDIR}"/patches-0.7.x/"${P}"-hangcheck.diff

	# UINT64_C is needed by ffmpeg headers
	append-flags -D__STDC_CONSTANT_MACROS

	if has_version ">=media-video/vdr-1.7.15"; then
		sed -e "s:2001:6419:" -i svdrpc.cpp
	fi

	epatch "${FILESDIR}/patches-0.7.x/${P}_gcc-4.7.diff"

	eautoreconf
}

src_configure() {

	local=myconf
	use ffmpeg && myconf="--with-ffmpeg --with-ffmpeginclude=/usr/include"

	econf \
	${myconf} \
	$(use_with imagemagick magick) \
	--with-mpeginclude=/usr/include/mpeg2dec
#	--with-tools # fails on showindex, marcpics compile
}

src_install() {

	dobin noad
#       fix me later!
#       dobin noad showindex
#	use imagemagick && dobin markpics

	dodoc README INSTALL
	# example scripts are installed as dokumentation
	dodoc allnewnoad allnoad allnoadnice clearlogos noadifnew stat2html

	newconfd "${FILESDIR}"/confd_vdraddon.noad vdraddon.noad

	insinto /usr/share/vdr/record
	doins "${FILESDIR}"/record-50-noad.sh

	insinto /usr/share/vdr/shutdown
	doins "${FILESDIR}"/pre-shutdown-15-noad.sh

	insinto /etc/vdr/reccmds
	doins "${FILESDIR}"/reccmds.noad.conf

	exeinto /usr/share/vdr/bin
	doexe "${FILESDIR}"/noad-reccmd
}

pkg_postinst() {

	elog
	elog "Congratulations, you have just installed noad!,"
	elog "To integrate noad in VDR you should do this:"
	elog
	elog "start and set Parameter in /etc/conf.d/vdraddon.noad"
	elog
	elog "Note: You can use here all pararmeters for noad,"
	elog "please look in the documentation of noad."
}
