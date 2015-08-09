# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Azoth, the modular IM client for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug doc astrality +acetamide +adiumstyles +autoidler +autopaste +birthdaynotifier
		+chathistory +crypt +depester +embedmedia +herbicide +hili +isterique
		+juick +keeso +lastseen	+metacontacts media +murm +latex +nativeemoticons
		+otroid +spell shx +standardstyles +vader velvetbird +woodpecker +xmpp +xtazy"

COMMON_DEPEND="~app-leechcraft/lc-core-${PV}
		dev-libs/qjson
		dev-qt/qtwebkit:4
		autoidler? ( x11-libs/libXScrnSaver )
		astrality? ( net-libs/telepathy-qt )
		otroid? ( net-libs/libotr )
		media? ( dev-qt/qt-mobility[multimedia] )
		woodpecker? ( dev-libs/kqoauth )
		xmpp? (
			>=net-libs/qxmpp-0.8.0
			media? ( >=net-libs/qxmpp-0.8.0[speex] )
		)
		xtazy? (
			~app-leechcraft/lc-xtazy-${PV}
			dev-qt/qtdbus:4
		)
		crypt? ( app-crypt/qca:2[qt4(+)] )"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen[dot] )"
RDEPEND="${COMMON_DEPEND}
	astrality? (
		net-im/telepathy-mission-control
		net-voip/telepathy-haze
	)
	crypt? ( app-crypt/qca:2[gpg] )
	latex? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
		virtual/latex-base
	)
	spell? (
		app-leechcraft/lc-rosenthal
	)"

REQUIRED_USE="|| ( standardstyles adiumstyles )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable crypt CRYPT)
		$(cmake-utils_use_with doc DOCS)
		$(cmake-utils_use_enable acetamide AZOTH_ACETAMIDE)
		$(cmake-utils_use_enable adiumstyles AZOTH_ADIUMSTYLES)
		$(cmake-utils_use_enable astrality AZOTH_ASTRALITY)
		$(cmake-utils_use_enable autoidler AZOTH_AUTOIDLER)
		$(cmake-utils_use_enable autopaste AZOTH_AUTOPASTE)
		$(cmake-utils_use_enable birthdaynotifier AZOTH_BIRTHDAYNOTIFIER)
		$(cmake-utils_use_enable chathistory AZOTH_CHATHISTORY)
		$(cmake-utils_use_enable depester AZOTH_DEPESTER)
		$(cmake-utils_use_enable embedmedia AZOTH_EMBEDMEDIA)
		$(cmake-utils_use_enable herbicide AZOTH_HERBICIDE)
		$(cmake-utils_use_enable hili AZOTH_HILI)
		$(cmake-utils_use_enable isterique AZOTH_ISTERIQUE)
		$(cmake-utils_use_enable juick AZOTH_JUICK)
		$(cmake-utils_use_enable keeso AZOTH_KEESO)
		$(cmake-utils_use_enable lastseen AZOTH_LASTSEEN)
		$(cmake-utils_use_enable metacontacts AZOTH_METACONTACTS)
		$(cmake-utils_use_enable media MEDIACALLS)
		$(cmake-utils_use_enable latex AZOTH_MODNOK)
		$(cmake-utils_use_enable murm AZOTH_MURM)
		$(cmake-utils_use_enable nativeemoticons AZOTH_NATIVEEMOTICONS)
		$(cmake-utils_use_enable otroid AZOTH_OTROID)
		$(cmake-utils_use_enable spell AZOTH_ROSENTHAL)
		$(cmake-utils_use_enable shx AZOTH_SHX)
		$(cmake-utils_use_enable standardstyles AZOTH_STANDARDSTYLES)
		$(cmake-utils_use_enable vader AZOTH_VADER)
		$(cmake-utils_use_enable velvetbird AZOTH_VELVETBIRD)
		$(cmake-utils_use_enable woodpecker AZOTH_WOODPECKER)
		$(cmake-utils_use_enable xmpp AZOTH_XOOX)
		$(cmake-utils_use_enable xtazy AZOTH_XTAZY)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/out/html/*
}

pkg_postinst() {
	if use spell; then
		elog "You have enabled the Azoth Rosenthal plugin for"
		elog "spellchecking. It uses Hunspell/Myspell dictionaries,"
		elog "so install the ones for languages you use to enable"
		elog "spellchecking."
	fi
}
