# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

PATCH_LEVEL=4

DESCRIPTION="A commandline tool displaying logical Hebrew/Arabic"
HOMEPAGE="http://packages.qa.debian.org/b/bidiv.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PATCH_LEVEL}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-libs/fribidi-0.19.2-r2"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	# Use order from "series" file:
	local ddir=${WORKDIR}/debian/patches
	epatch \
		"${ddir}"/try_utf8_fix \
		"${ddir}"/makefile \
		"${ddir}"/fribidi_019 \
		"${ddir}"/hyphen_minus \
		"${ddir}"/term_size_get \
		"${ddir}"/type_fix \
		"${ddir}"/cast_fix
}

src_compile() {
	tc-export CC
	emake CC_OPT_FLAGS="-Wall"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README WHATSNEW "${WORKDIR}"/debian/changelog
}
