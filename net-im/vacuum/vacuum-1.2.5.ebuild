# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN}-im
PLOCALES="de es pl ru uk"
inherit cmake-utils l10n

DESCRIPTION="Qt Crossplatform Jabber client"
HOMEPAGE="https://code.google.com/p/vacuum-im"
SRC_URI="https://github.com/Vacuum-IM/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/1.17" # subslot = libvacuumutils soname version
KEYWORDS="~amd64 ~x86"
PLUGINS=( annotations autostatus avatars birthdayreminder bitsofbinary bookmarks captchaforms chatstates clientinfo commands compress console dataforms datastreamsmanager emoticons filemessagearchive filestreamsmanager filetransfer gateways inbandstreams iqauth jabbersearch messagearchiver multiuserchat pepmanager privacylists privatestorage registration remotecontrol rosteritemexchange rostersearch servermessagearchive servicediscovery sessionnegotiation shortcutmanager socksstreams urlprocessor vcard xmppuriqueries )
IUSE="${PLUGINS[@]/#/+}"

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
	pepmanager? ( servicediscovery )
	registration? ( dataforms )
	remotecontrol? ( commands dataforms )
	servermessagearchive? ( messagearchiver )
	sessionnegotiation? ( dataforms )
"

RDEPEND="
	dev-qt/qtcore:4[ssl]
	dev-qt/qtgui:4
	dev-qt/qtlockedfile[qt4(+)]
	dev-libs/openssl:0
	net-dns/libidn
	sys-libs/zlib[minizip]
	x11-libs/libXScrnSaver
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS CHANGELOG README TRANSLATORS )

PATCHES=( "${FILESDIR}"/${PN}-1.2.4-gcc6-not-string-literals.patch )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# Force usage of system libraries
	rm -rf src/thirdparty/{idn,minizip,zlib}

	# CMP0022 warning
	sed -e "/^cmake_minimum_required/s/2.8/2.8.12/" -i CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DINSTALL_SDK=ON
		-DLANGS="$(l10n_get_locales)"
		-DINSTALL_DOCS=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
	)

	local x
	for x in ${PLUGINS[@]}; do
		mycmakeargs+=( -DPLUGIN_${x}=$(usex $x) )
	done

	cmake-utils_src_configure
}
