# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vdr-plugin-2

HG_REVISION="7a48070da75b"
HG_REVISION_DATE="20130409"

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' TechnoTrend
S2-6400 DVB Card"
HOMEPAGE="http://powarman.dyndns.org/hg/dvbhddevice"
SRC_URI="http://powarman.dyndns.org/hgwebdir.cgi/dvbhddevice/archive/${HG_REVISION}.tar.gz
-> dvbhddevice-0.0.9_p${HG_REVISION_DATE}.tar.gz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.7.39"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dvbhddevice-${HG_REVISION}"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include dvbhdffdevice.c
}

src_install() {
	vdr-plugin-2_src_install

	doheader dvbhdffdevice.h hdffcmd.h

	insinto /usr/include/libhdffcmd
	doins libhdffcmd/*.h
}
