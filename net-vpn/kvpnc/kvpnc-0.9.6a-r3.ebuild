# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

QT3SUPPORT_REQUIRED="true"
KDE_LINGUAS="ar br cs da de el en_GB eo es et eu fr ga gl hi hne it ja ka lt
ms nb nds nl nn pa pl pt pt_BR ro ru sv tr uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDELibs4-based frontend for various VPN clients"
HOMEPAGE="https://userbase.kde.org/KVpnc"
SRC_URI="http://download.gna.org/kvpnc/${P}-kde4.tar.bz2
	http://download.gna.org/kvpnc/${P/a}-kde4-locale.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/libgcrypt:0
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S=${WORKDIR}/${P}-kde4

PATCHES=(
	"${FILESDIR}/${P}-scriptsec.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-ifconfig.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-kicon.patch"
)

src_prepare() {
	mv -vf "${WORKDIR}"/${P/a}-kde4-locale/po . || die

	echo "find_package ( Msgfmt REQUIRED )" >> CMakeLists.txt || die
	echo "find_package ( Gettext REQUIRED )" >> CMakeLists.txt || die
	echo "add_subdirectory ( po )" >> CMakeLists.txt || die

	sed -i \
		-e "s:0.9.2-svn:${PV}:" \
		CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_libgcrypt=ON
	)
	kde4-base_src_configure
}
