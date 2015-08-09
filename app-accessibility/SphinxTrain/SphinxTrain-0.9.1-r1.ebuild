# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Speech Recognition (Training Module)"
HOMEPAGE="http://cmusphinx.sourceforge.net/html/cmusphinx.php"
SRC_URI="http://www.speech.cs.cmu.edu/${PN}/${P}-beta.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="app-accessibility/sphinx2
	app-accessibility/festival"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/gcc.patch
	epatch "${FILESDIR}"/gcc34.patch
	tc-export CC AR RANLIB
}

src_install() {
	# dobin bin.*/* fails ... see bug #73586
	find bin.* -mindepth 1 -maxdepth 1 -type f -exec dobin '{}' \; || die

	dodoc README etc/*cfg
	dohtml doc/*{txt,html,sgml}
}

pkg_postinst() {
	elog "Detailed usage and training instructions can be found at"
	elog "http://www.speech.cs.cmu.edu/SphinxTrain/"
}
