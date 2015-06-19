# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/yagf/yagf-0.9.2.ebuild,v 1.7 2013/03/24 15:39:45 hwoarang Exp $

EAPI="5"

CMAKE_IN_SOURCE_BUILD=1
PLOCALES="de lt pl ru uk"
inherit cmake-utils l10n

DESCRIPTION="Graphical front-end for cuneiform and tesseract OCR tools"
HOMEPAGE="http://symmetrica.net/cuneiform-linux/yagf-en.html"
SRC_URI="http://symmetrica.net/cuneiform-linux/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scanner cuneiform +tesseract pdf"

REQUIRED_USE="|| ( cuneiform tesseract )"

DEPEND=">=dev-qt/qtgui-4.7:4
	app-text/aspell"
RDEPEND="${DEPEND}
	cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )
	scanner? ( media-gfx/xsane )
	pdf? ( || ( app-text/poppler[utils] app-text/ghostscript-gpl ) )"

DOCS=( AUTHORS ChangeLog DESCRIPTION README )

src_prepare() {
	l10n_find_plocales_changes "src/translations" "${PN}_" '.ts'

	epatch_user
}

src_install() {
	remove_translation() {
		rm "${ED}/usr/share/yagf/translations/${PN}_${1}.qm" || die "remove '${PN}_${1}.qm' file failed"
	}
	cmake-utils_src_install
	l10n_for_each_disabled_locale_do remove_translation
}
