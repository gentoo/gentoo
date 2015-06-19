# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvbhddevice/vdr-dvbhddevice-2.1.6_p20141116-r1.ebuild,v 1.1 2015/02/20 12:46:49 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

HG_REVISION="88cd727ebc99"
HG_REVISION_DATE="20141116"

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' TechnoTrend
S2-6400 DVB Card"
HOMEPAGE="https://bitbucket.org/powARman/dvbhddevice"
SRC_URI="https://bitbucket.org/powARman/dvbhddevice/get/${HG_REVISION}.tar.gz ->
		${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"

S="${WORKDIR}/powARman-${VDRPLUGIN}-${HG_REVISION}"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include dvbhdffdevice.c

	if has_version ">=media-video/vdr-2.1.10"; then
		sed -e "s:pm = RenderPixmaps():pm = dynamic_cast<cPixmapMemory *>(RenderPixmaps()):"\
			-e "s:delete pm;:DestroyPixmap(pm);:"\
			-i hdffosd.c
	fi
}

src_install() {
	vdr-plugin-2_src_install

	doheader dvbhdffdevice.h hdffcmd.h

	insinto /usr/include/libhdffcmd
	doins libhdffcmd/*.h
}
