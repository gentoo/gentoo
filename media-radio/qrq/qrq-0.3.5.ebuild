# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Yet another CW trainer for Linux/Unix"
HOMEPAGE="http://fkurz.net/ham/qrq.html"
SRC_URI="http://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="pulseaudio"

DEPEND="sys-libs/ncurses:=
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.3.2-tinfo.patch" )

src_prepare() {
	# avoid prestripping of 'qrq' binary
	sed -i -e "s/INSTALL} -s -m/INSTALL} -m/" Makefile || die
	sed -i -e "s/CC=gcc/CC=$(tc-getCC)/" Makefile || die
	default
}

src_compile() {
	CONF="USE_PA=NO USE_OSS=YES"
	if use pulseaudio; then
		CONF="USE_PA=YES USE_OSS=NO"
	fi
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)" ${CONF}
}

src_install() {
	emake ${CONF} DESTDIR="${D}/usr" install
	dodoc AUTHORS ChangeLog README
}
