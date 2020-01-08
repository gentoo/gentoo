# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Preview dvi-files on text-only devices"
HOMEPAGE="http://www.ctan.org/tex-archive/dviware/"
SRC_URI="ftp://ftp.mesa.nl/pub/dvi2tty/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-cflags.patch
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin dvi2tty disdvi
	doman dvi2tty.1 disdvi.1
	dodoc README TODO
}
