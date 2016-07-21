# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Interactive tool for astronomical ephemeris and sky simulation"
HOMEPAGE="http://www.clearskyinstitute.com/xephem"
SRC_URI="http://97.74.56.125/free/${P}.tar.gz"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
SLOT=0
LICENSE="XEphem"

DEPEND=">=x11-libs/motif-2.3:0
	virtual/jpeg
	media-libs/libpng"
RDEPEND="${DEPEND}"

src_prepare() {
	# make sure we use system libs and respect user flags
	epatch \
		"${FILESDIR}"/${PN}-3.7.4-libs-flags.patch \
		"${FILESDIR}"/${PN}-3.7.4-overflows.patch \
		"${FILESDIR}"/${P}-respect-flags.patch
}

src_compile() {
	tc-export CC AR RANLIB
	cd GUI/xephem || die
	emake
	local i
	for i in tools/{lx200xed,xedb,xephemdbd}; do
		emake -C ${i}
	done
}

src_install() {
	cd GUI/xephem
	dobin xephem
	doman xephem.1
	newicon XEphem.png ${PN}.png
	insinto /usr/share/${PN}
	doins -r auxil catalogs fifos fits gallery lo
	dohtml -r help/*
	cd tools || die
	dobin lx200xed/lx200xed xedb/xedb xephemdbd/xephemdbd
	for file in {xedb,lx200xed}/README; do
		newdoc ${file} README.$(dirname ${file})
	done
	cd xephemdbd || die
	insinto /usr/share/doc/${PF}/xephemdbd
	doins README cgi-lib.pl start-xephemdbd.pl xephemdbd.html xephemdbd.pl
	cd "${S}"
	echo > XEphem "XEphem.ShareDir: /usr/share/${PN}"
	insinto /usr/share/X11/app-defaults
	has_version '<x11-base/xorg-x11-7.0' && insinto /etc/X11/app-defaults
	doins XEphem
	echo > 99xephem "XEHELPURL=/usr/share/doc/${PF}/html/xephem.html"
	doenvd 99xephem
	dodoc Copyright README
	make_desktop_entry xephem XEphem ${PN}
}

pkg_postinst() {
	elog "See ${EROOT}/usr/share/doc/${PF}/xephemdbd/README to set up a web interface"
}
