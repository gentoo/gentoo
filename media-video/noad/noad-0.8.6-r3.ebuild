# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils toolchain-funcs

DESCRIPTION="Mark commercial breaks in VDR recordings"
HOMEPAGE="http://noad.net23.net/"
SRC_URI="http://noad.net23.net/${P}.tar.bz2
		http://vdr.websitec.de/download/${PN}/${P}-ffmpeg3.4.diff.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+ffmpeg imagemagick libmpeg2"

RDEPEND="
	libmpeg2? ( media-libs/libmpeg2:= )
	ffmpeg? ( virtual/ffmpeg )
	imagemagick? ( media-gfx/imagemagick )
	!media-plugins/vdr-markad"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="|| ( ffmpeg libmpeg2 )"

src_prepare() {
	default

	#compile tested libav-13, ffmepg-3.4
	eapply "${WORKDIR}/${P}-ffmpeg3.4.diff"

	eautoreconf
}

src_configure() {
	econf \
		$(usex imagemagick '--with-magick') \
		$(usex ffmpeg '' '--without-ffmpeg') \
		$(usex libmpeg2 '' '--without-libmpeg2') \
		--with-tools
}

src_compile() {
	emake AR="$(tc-getAR)"		# see bug #469810
}

src_install() {
	dobin noad showindex checkMarks
	use imagemagick && dobin markpics

	dodoc README INSTALL
	# example scripts are installed as dokumentation
	dodoc allnewnoad allnoad allnoadnice clearlogos noadcall.sh noadifnew stat2html statupd

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
	elog "To integrate noad in VDR you should do this:"
	elog
	elog "start and set Parameter in /etc/conf.d/vdraddon.noad"
	elog
	elog "Note: You can use here all parameters for noad,"
	elog "please look in the documentation of noad."
}
