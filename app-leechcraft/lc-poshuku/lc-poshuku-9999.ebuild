# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit leechcraft

DESCRIPTION="Poshuku, the full-featured web browser plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="+autosearch debug +dcac +cleanweb +fatape +filescheme +foc +fua +idn +keywords +onlinebookmarks
	  postgres qrd +speeddial +sqlite webengineview +webkitview"

DEPEND="~app-leechcraft/lc-core-${PV}[postgres?,sqlite?]
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	dev-qt/qtprintsupport:5
	cleanweb? ( dev-qt/qtconcurrent:5 )
	idn? ( net-dns/libidn )
	qrd? ( media-gfx/qrencode )
	webkitview? ( dev-qt/qtwebkit:5 )
	webengineview? ( dev-qt/qtwebengine:5 )
"
RDEPEND="${DEPEND}
	virtual/leechcraft-downloader-http"

REQUIRED_USE="|| ( postgres sqlite )
	|| ( webkitview webengineview )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_POSHUKU_AUTOSEARCH=$(usex autosearch)
		-DENABLE_POSHUKU_CLEANWEB=$(usex cleanweb)
		-DENABLE_POSHUKU_DCAC=$(usex dcac)
		-DENABLE_POSHUKU_FATAPE=$(usex fatape)
		-DENABLE_POSHUKU_FILESCHEME=$(usex filescheme)
		-DENABLE_POSHUKU_FOC=$(usex foc)
		-DENABLE_POSHUKU_FUA=$(usex fua)
		-DENABLE_IDN=$(usex idn)
		-DENABLE_POSHUKU_KEYWORDS=$(usex keywords)
		-DENABLE_POSHUKU_ONLINEBOOKMARKS=$(usex onlinebookmarks)
		-DENABLE_POSHUKU_QRD=$(usex qrd)
		-DENABLE_POSHUKU_SPEEDDIAL=$(usex speeddial)
		-DENABLE_POSHUKU_WEBKITVIEW=$(usex webkitview)
		-DENABLE_POSHUKU_WEBENGINEVIEW=$(usex webengineview)
	)

	cmake-utils_src_configure
}
