# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="microwave CAD software"
HOMEPAGE="https://www.pa3fwm.nl/software/puff/"
SRC_URI="https://www.pa3fwm.nl/software/${PN}/${P}.tgz"

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
	eapply -p0 "${FILESDIR}"/${P}-Makefile.patch
	eapply_user
}

src_compile() {
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
