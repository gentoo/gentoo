# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Azoth, the modular IM client for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug doc +acetamide +adiumstyles astrality +autoidler +autopaste +birthdaynotifier
	+chathistory +crypt +depester +embedmedia +herbicide +hili +isterique +juick
	+keeso +lastseen +latex media +metacontacts +murm +nativeemoticons +otroid sarin
	shx +spell +standardstyles +vader velvetbird +woodpecker +xmpp +xtazy"

REQUIRED_USE="|| ( standardstyles adiumstyles )"

COMMON_DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtxml:5
	astrality? ( net-libs/telepathy-qt[qt5(+)] )
	autoidler? (
		dev-qt/qtx11extras:5
		x11-libs/libXScrnSaver
	)
	crypt? ( app-crypt/qca:2[qt5(+)] )
	lastseen? ( dev-qt/qtconcurrent:5 )
	media? ( dev-qt/qtmultimedia:5 )
	otroid? (
		dev-qt/qtconcurrent:5
		net-libs/libotr
	)
	sarin? (
		dev-qt/qtconcurrent:5
		net-libs/tox
	)
	woodpecker? ( dev-libs/kqoauth )
	xmpp? (
		>=net-libs/qxmpp-0.9.3-r1
		media? ( net-libs/qxmpp[speex] )
	)
	xtazy? ( ~app-leechcraft/lc-xtazy-${PV} )
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen[dot] )
"
RDEPEND="${COMMON_DEPEND}
	astrality? (
		net-im/telepathy-mission-control
		net-voip/telepathy-haze
	)
	crypt? ( app-crypt/qca:2[gpg] )
	latex? (
		virtual/imagemagick-tools
		virtual/latex-base
	)
	spell? ( ~app-leechcraft/lc-rosenthal-${PV} )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_CRYPT=$(usex crypt)
		-DWITH_DOCS=$(usex doc)
		-DENABLE_AZOTH_ACETAMIDE=$(usex acetamide)
		-DENABLE_AZOTH_ADIUMSTYLES=$(usex adiumstyles)
		-DENABLE_AZOTH_ASTRALITY=$(usex astrality)
		-DENABLE_AZOTH_AUTOIDLER=$(usex autoidler)
		-DENABLE_AZOTH_AUTOPASTE=$(usex autopaste)
		-DENABLE_AZOTH_BIRTHDAYNOTIFIER=$(usex birthdaynotifier)
		-DENABLE_AZOTH_CHATHISTORY=$(usex chathistory)
		-DENABLE_AZOTH_DEPESTER=$(usex depester)
		-DENABLE_AZOTH_EMBEDMEDIA=$(usex embedmedia)
		-DENABLE_AZOTH_HERBICIDE=$(usex herbicide)
		-DENABLE_AZOTH_HILI=$(usex hili)
		-DENABLE_AZOTH_ISTERIQUE=$(usex isterique)
		-DENABLE_AZOTH_JUICK=$(usex juick)
		-DENABLE_AZOTH_KEESO=$(usex keeso)
		-DENABLE_AZOTH_LASTSEEN=$(usex lastseen)
		-DENABLE_AZOTH_MODNOK=$(usex latex)
		-DENABLE_AZOTH_METACONTACTS=$(usex metacontacts)
		-DENABLE_MEDIACALLS=$(usex media)
		-DENABLE_AZOTH_MURM=$(usex murm)
		-DENABLE_AZOTH_NATIVEEMOTICONS=$(usex nativeemoticons)
		-DENABLE_AZOTH_OTROID=$(usex otroid)
		-DENABLE_AZOTH_SARIN=$(usex sarin)
		-DENABLE_AZOTH_SHX=$(usex shx)
		-DENABLE_AZOTH_ROSENTHAL=$(usex spell)
		-DENABLE_AZOTH_STANDARDSTYLES=$(usex standardstyles)
		-DENABLE_AZOTH_VADER=$(usex vader)
		-DENABLE_AZOTH_VELVETBIRD=$(usex velvetbird)
		-DENABLE_AZOTH_WOODPECKER=$(usex woodpecker)
		-DENABLE_AZOTH_XOOX=$(usex xmpp)
		-DENABLE_AZOTH_XTAZY=$(usex xtazy)
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
