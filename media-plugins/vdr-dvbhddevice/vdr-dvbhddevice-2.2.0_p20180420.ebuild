# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

HG_REVISION="2ea854ae8c7a"
HG_REVISION_DATE="20180420"

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' TechnoTrend
S2-6400 DVB Card"
HOMEPAGE="https://bitbucket.org/powARman/dvbhddevice"
SRC_URI="https://bitbucket.org/powARman/dvbhddevice/get/${HG_REVISION}.tar.gz ->
		${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/powARman-${VDRPLUGIN}-${HG_REVISION}"

src_prepare() {
	vdr-plugin-2_src_prepare

	eapply "${FILESDIR}/define_AUDIO_GET_PTS.patch"
	fix_vdr_libsi_include dvbhdffdevice.c
}

src_install() {
	vdr-plugin-2_src_install

	doheader dvbhdffdevice.h hdffcmd.h
	insinto /usr/include/libhdffcmd
	doins libhdffcmd/*.h
}
