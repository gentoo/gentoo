# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

HG_REVISION="60c58ae453d0"
HG_REVISION_DATE="20140115"

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' TechnoTrend
S2-6400 DVB Card"
HOMEPAGE="https://bitbucket.org/powARman/dvbhddevice"
SRC_URI="https://bitbucket.org/powARman/dvbhddevice/get/${HG_REVISION}.tar.gz
-> dvbhddevice-2.1.3_p${HG_REVISION_DATE}.tar.gz"

KEYWORDS="amd64 x86"
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
