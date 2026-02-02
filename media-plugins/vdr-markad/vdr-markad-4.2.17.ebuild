# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: mark advertising in VDR recordings"
HOMEPAGE="https://github.com/kfb77/vdr-plugin-markad/"
SRC_URI="https://github.com/kfb77/vdr-plugin-markad/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-markad-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr:=
	media-video/ffmpeg[lame]
	!media-video/noad"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}/vdr-markad-Makefile.patch"
	S="${WORKDIR}/vdr-plugin-markad-${PV}/plugin"
	vdr-plugin-2_src_prepare
	cp ../version.dist ../version.h || die
}

src_compile() {
	S="${WORKDIR}/vdr-plugin-markad-${PV}/"
	vdr-plugin-2_src_compile
}

src_install() {
	S="${WORKDIR}/vdr-plugin-markad-${PV}/plugin"
	vdr-plugin-2_src_install

	cd "${S}/.." || die
	emake install DESTDIR="${D}"

	S="${WORKDIR}/vdr-plugin-markad-${PV}/"
	dodoc README HISTORY
}
