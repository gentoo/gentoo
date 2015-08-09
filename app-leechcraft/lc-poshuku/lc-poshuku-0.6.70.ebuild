# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit confutils leechcraft

DESCRIPTION="Poshuku, the full-featured web browser plugin for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="+autosearch debug +dcac +cleanweb +fatape +filescheme +fua +idn +keywords +onlinebookmarks
		+pcre postgres qrd +sqlite wyfv"

DEPEND="~app-leechcraft/lc-core-${PV}[postgres?,sqlite?]
		dev-qt/qtwebkit:4
		idn? ( net-dns/libidn )
		onlinebookmarks? ( >=dev-libs/qjson-0.7.1-r1 )
		pcre? ( >=dev-libs/libpcre-8.12 )
		qrd? ( media-gfx/qrencode )
"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

REQUIRED_USE="pcre? ( cleanweb )"

pkg_setup() {
	confutils_require_any postgres sqlite
}

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable autosearch POSHUKU_AUTOSEARCH)
		$(cmake-utils_use_enable cleanweb POSHUKU_CLEANWEB)
		$(cmake-utils_use_enable dcac POSHUKU_DCAC)
		$(cmake-utils_use_enable fatape POSHUKU_FATAPE)
		$(cmake-utils_use_enable filescheme POSHUKU_FILESCHEME)
		$(cmake-utils_use_enable fua POSHUKU_FUA)
		$(cmake-utils_use_enable idn IDN)
		$(cmake-utils_use_enable keywords POSHUKU_KEYWORDS)
		$(cmake-utils_use_enable onlinebookmarks POSHUKU_ONLINEBOOKMARKS)
		$(cmake-utils_use_enable qrd POSHUKU_QRD)
		$(cmake-utils_use_enable pcre POSHUKU_CLEANWEB_PCRE)
		$(cmake-utils_use_enable wyfv POSHUKU_WYFV)
		"

	cmake-utils_src_configure
}
