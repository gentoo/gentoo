# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/Vacuum-IM/vacuum-im.git"
PLOCALES="de es pl ru uk"
inherit cmake-utils git-r3 l10n

DESCRIPTION="Qt Crossplatform Jabber client"
HOMEPAGE="http://www.vacuum-im.org/"

LICENSE="GPL-3"
SLOT="0/37" # subslot = libvacuumutils soname version
KEYWORDS=""
PLUGINS=( adiummessagestyle annotations autostatus avatars birthdayreminder bitsofbinary bookmarks captchaforms chatstates clientinfo commands compress console dataforms datastreamsmanager emoticons filemessagearchive filestreamsmanager filetransfer gateways inbandstreams iqauth jabbersearch messagearchiver messagecarbons multiuserchat pepmanager privacylists privatestorage recentcontacts registration remotecontrol rosteritemexchange rostersearch servermessagearchive servicediscovery sessionnegotiation shortcutmanager socksstreams urlprocessor vcard xmppuriqueries )
SPELLCHECKER_BACKENDS="aspell +enchant hunspell"
IUSE="${PLUGINS[@]/#/+} ${SPELLCHECKER_BACKENDS} +spell"

REQUIRED_USE="
	annotations? ( privatestorage )
	avatars? ( vcard )
	birthdayreminder? ( vcard )
	bookmarks? ( privatestorage )
	captchaforms? ( dataforms )
	commands? ( dataforms )
	datastreamsmanager? ( dataforms )
	filemessagearchive? ( messagearchiver )
	filestreamsmanager? ( datastreamsmanager )
	filetransfer? ( filestreamsmanager datastreamsmanager )
	messagecarbons? ( servicediscovery )
	pepmanager? ( servicediscovery )
	recentcontacts? ( privatestorage )
	registration? ( dataforms )
	remotecontrol? ( commands dataforms )
	servermessagearchive? ( messagearchiver )
	sessionnegotiation? ( dataforms )
	spell? ( ^^ ( ${SPELLCHECKER_BACKENDS//+/} ) )
"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtlockedfile[qt5(+)]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	net-dns/libidn
	sys-libs/zlib[minizip]
	x11-libs/libXScrnSaver
	adiummessagestyle? ( dev-qt/qtwebkit:5 )
	filemessagearchive? ( dev-qt/qtsql:5[sqlite] )
	messagearchiver? ( dev-qt/qtsql:5[sqlite] )
	spell? (
		aspell? ( app-text/aspell )
		enchant? ( app-text/enchant:0 )
		hunspell? ( app-text/hunspell )
	)
"
RDEPEND="${DEPEND}
	!net-im/vacuum-spellchecker
"

DOCS=( AUTHORS CHANGELOG README TRANSLATORS )

src_prepare() {
	# Force usage of system libraries
	rm -rf src/thirdparty/{hunspell,idn,minizip,qtlockedfile,zlib} || die

	# Supress find thirdparty library in the system
	sed -i -r -e "/find_library.+qxtglobalshortcut/d" \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DINSTALL_SDK=ON
		-DLANGS="$(l10n_get_locales)"
		-DINSTALL_DOCS=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
		-DPLUGIN_statistics=OFF
		-DPLUGIN_spellchecker=$(usex spell)
	)

	for x in ${PLUGINS[@]}; do
		mycmakeargs+=( -DPLUGIN_${x}=$(usex $x) )
	done

	for i in ${SPELLCHECKER_BACKENDS//+/}; do
		use "${i}" && mycmakeargs+=( -DSPELLCHECKER_BACKEND="${i}" )
	done

	cmake-utils_src_configure
}
