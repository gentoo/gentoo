# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="fr ru"
inherit cmake-utils l10n multilib

DESCRIPTION="Graphical front-end for cuneiform and tesseract OCR tools"
HOMEPAGE="http://symmetrica.net/cuneiform-linux/yagf-en.html"
SRC_URI="http://symmetrica.net/cuneiform-linux/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scanner cuneiform +tesseract pdf"

REQUIRED_USE="|| ( cuneiform tesseract )"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	app-text/aspell
"
RDEPEND="${DEPEND}
	cuneiform? ( app-text/cuneiform )
	tesseract? ( app-text/tesseract )
	scanner? ( media-gfx/xsane )
	pdf? ( || ( app-text/poppler[utils] app-text/ghostscript-gpl ) )
"

DOCS=( AUTHORS ChangeLog DESCRIPTION README )

src_prepare() {
	# respect CFLAGS and fix translations path
	sed -i \
		-e '/add_definitions(-Wall -g)/d' \
		-e '/-DQML_INSTALL_PATH=/s:${QML_DESTINATION}:/${QML_DESTINATION}:' \
		CMakeLists.txt || die 'sed on CMakeLists.txt failed'

	l10n_find_plocales_changes "src/translations" "${PN}_" '.ts'
	cmake-utils_src_prepare
}

src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIB_PATH_SUFFIX=${libdir#lib}
	)
	cmake-utils_src_configure
}

src_install() {
	remove_translation() {
		rm "${ED}/usr/share/yagf/translations/${PN}_${1}.qm" || die "remove '${PN}_${1}.qm' file failed"
	}
	cmake-utils_src_install
	l10n_for_each_disabled_locale_do remove_translation
}
