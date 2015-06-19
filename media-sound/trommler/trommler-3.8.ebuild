# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/trommler/trommler-3.8.ebuild,v 1.9 2014/08/10 21:12:43 slyfox Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="GTK+ based drum machine"
HOMEPAGE="http://muth.org/Robert/Trommler"
SRC_URI="http://muth.org/Robert/${PN/t/T}/${P/-/.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~sparc x86"
IUSE="+sox"

RDEPEND="x11-libs/gtk+:2
	sox? ( media-sound/sox )"
DEPEND="${RDEPEND}
	x11-misc/makedepend
	virtual/pkgconfig"

S=${WORKDIR}/${PN/t/T}

src_prepare() {
	sed -i \
		-e 's:$(CC):$(CC) $(LDFLAGS):' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake export.h || die
	emake CFLAGS="${CFLAGS} -Wall $(pkg-config --cflags gtk+-2.0)" || die
}

src_install() {
	exeinto /usr/libexec
	doexe ${PN} || die

	newbin "${FILESDIR}"/${PN}.wrapper ${PN} || die
	dobin wav2smp playsample || die
	use sox && { dobin smp2wav || die; }

	insinto /usr/share/${PN}/Drums
	doins Drums/*.smp || die
	insinto /usr/share/${PN}/Songs
	doins Songs/*.sng || die

	dodoc CHANGES README
	dohtml index.html style.css

	make_desktop_entry ${PN} Trommler
}
