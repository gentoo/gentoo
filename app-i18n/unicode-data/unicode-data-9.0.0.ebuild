# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Unicode data from unicode.org"
HOMEPAGE="http://www.unicode.org/ucd/"
SRC_URI="http://www.unicode.org/Public/zipped/${PV}/UCD.zip -> ${P}-UCD.zip
	http://www.unicode.org/Public/zipped/${PV}/Unihan.zip -> ${P}-Unihan.zip"

LICENSE="unicode"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	# Unihan.zip needs to be installed as a zip for reverse deps
	# https://bugzilla.gnome.org/show_bug.cgi?id=768210
	unpack ${P}-UCD.zip
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${S}"/*
	newins "${DISTDIR}"/${P}-Unihan.zip Unihan.zip
}
