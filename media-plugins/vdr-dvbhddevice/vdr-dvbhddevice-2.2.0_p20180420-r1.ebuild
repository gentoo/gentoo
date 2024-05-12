# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

# 2018/04/20
REVISION="6a3e75484d90"

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' TechnoTrend S2-6400 DVB Card"
HOMEPAGE="https://bitbucket.org/powARman/dvbhddevice"
SRC_URI="https://bitbucket.org/powARman/dvbhddevice/get/${REVISION}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/powARman-${VDRPLUGIN}-${REVISION}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/convert-bool-fix.patch"
	"${FILESDIR}/define_AUDIO_GET_PTS.patch" )
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-dvbhddevice.*
	usr/lib64/vdr/plugins/libvdr-dvbhddevice.*"

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
