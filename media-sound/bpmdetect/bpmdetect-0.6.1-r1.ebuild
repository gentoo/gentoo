# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Automatic BPM detection utility"
HOMEPAGE="http://sourceforge.net/projects/bpmdetect"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/taglib
	media-libs/id3lib
	>=media-libs/fmod-4.25.07-r1:1
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	sys-apps/sed
	dev-util/scons
	virtual/pkgconfig"

S=${WORKDIR}/${PN}
PATCHES=(
	"${FILESDIR}/${P}-gcc44_and_fmodex_path.patch"
	"${FILESDIR}/${P}-fix-buildsystem.patch"
	"${FILESDIR}/${P}-fix-printf-format.patch"
)

src_prepare() {
	default
	tc-export CC CXX
}

src_configure() {
	:
}

src_compile() {
	export QTDIR="/usr/$(get_libdir)"
	scons prefix=/usr || die "scons failed"
}

src_install() {
	dobin build/${PN}
	doicon src/${PN}-icon.png
	domenu src/${PN}.desktop
	dodoc authors readme todo
}
