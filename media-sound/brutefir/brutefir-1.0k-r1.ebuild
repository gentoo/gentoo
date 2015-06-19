# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/brutefir/brutefir-1.0k-r1.ebuild,v 1.3 2012/02/16 18:52:28 phajdan.jr Exp $

EAPI=2
inherit eutils multilib toolchain-funcs

DESCRIPTION="Software convolution engine for applying long FIR filters"
HOMEPAGE="http://www.ludd.luth.se/~torger/brutefir.html"
SRC_URI="http://www.ludd.luth.se/~torger/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ld.patch
}

src_compile() {
	tc-export AS CC
	emake || die "emake failed"
}

src_install() {
	emake LIBDIR="/usr/$(get_libdir)" DESTDIR="${D}" \
		install || die "emake install failed"
	dodoc CHANGES README

	insinto /usr/share/${PN}
	doins xtc_config directpath.txt crosspath.txt massive_config \
		bench1_config bench2_config bench3_config bench4_config \
		bench5_config || die "doins failed"
}

pkg_postinst() {
	elog "Brutefir is a complicated piece of software. Please"
	elog "read the documentation first! You can find"
	elog "documentation here: http://www.ludd.luth.se/~torger/brutefir.html"
	elog "Example config files are in /usr/share/brutefir"
}
