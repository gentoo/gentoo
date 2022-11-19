# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

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
	# respect CC and LD
	# additional drop explicite format option for linker (bug #831569)
	eapply -p0 "${FILESDIR}"/$P-Makefile.patch
	# add missing LDPATH for libX11.so
	sed -i -e "s:-lX11:-L/usr/$(get_libdir) -lX11:g" Makefile || die
	# drop no longer needed and now unsupported paramter '-T' (bug #8802225)
	sed -i -e "s: -T : :g" Makefile || die
	eapply_user
}

src_compile() {
#	# fails to compile with -flto (bug #862516)
	filter-lto
	LDFLAGS="$(raw-ldflags)"
	emake -j1 CC="$(tc-getCC)" LD="$(tc-getLD)"
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
