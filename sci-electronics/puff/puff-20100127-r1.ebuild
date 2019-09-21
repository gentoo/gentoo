# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="microwave CAD software"
HOMEPAGE="https://wwwhome.cs.utwente.nl/~ptdeboer/ham/puff/"
SRC_URI="https://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-lang/fpc"

src_prepare() {
	default
	# fix lib path for X11 and dont ignore LDFLAGS
	sed -i -e "s#lib\\\/#$(get_libdir)\\\/#" \
		-e 's/CFLAGS/#CFLAGS/' \
		-e 's/link.res pu/link.res $(LDFLAGS) pu/' Makefile || die
}

src_compile() {
	LDFLAGS="$(raw-ldflags)"
	emake -j1
}

src_install() {
	dobin puff

	dodoc changelog.txt README.txt
	newdoc "Puff Manual.pdf" Puff_Manual.pdf

	insinto /usr/share/${PN}
	doins setup.puf
	doins -r orig_dev_and_puf_files
}

pkg_postinst() {
	elog "You must copy /usr/share/${PN}/setup.puf into your working directory"
	elog "before using the program."
}
