# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="An OCR (Optical Character Recognition) program"
SRC_URI="mirror://gentoo/clara-20031214.tar.gz"
HOMEPAGE="http://www.claraocr.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~ppc-macos ~sparc-solaris"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

# The test provided by clara doesn't seem to make any sense.  It just
# calls the binary with an unsupported option, which results in an
# error.
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -re "s/(C|LD)FLAGS =/\1FLAGS +=/" Makefile
	epatch "${FILESDIR}/clara_open_mode.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
	emake doc || die
}

src_install() {
	dobin clara selthresh
	doman doc/clara*.1 selthresh.1

	dodoc ANNOUNCE CHANGELOG doc/FAQ
	insinto /usr/share/doc/${P}
	doins imre.pbm

	dohtml doc/*.html
}

pkg_postinst() {
	elog
	elog "Please note that Clara OCR has to be trained to recognize text,"
	elog "without a training session it simply won't work. Have a look at"
	elog "the docs in /usr/share/doc/${P}/html/ to get more "
	elog "info about the training procedure."
	elog
}
