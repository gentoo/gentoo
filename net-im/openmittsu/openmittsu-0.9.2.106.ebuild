# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="An open source chat client for Threema-style end-to-end encrypted chat networks"
HOMEPAGE="https://www.openmittsu.de/"
# git-archive-all.sh snapshot of https://github.com/blizzard4591/openMittsu.git
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+ BitstreamVera OFL-1.1 Apache-2.0 CC0-1.0 MIT BSD-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libsodium-1.0.11:=
	>=dev-qt/qtcore-5.7.1:5=
	>=dev-qt/qtgui-5.7.1:5=
	>=dev-qt/qtmultimedia-5.7.1:5=
	>=dev-qt/qtnetwork-5.7.1:5=
	>=dev-qt/qtsql-5.7.1:5=[sqlite]
	>=dev-qt/qtwidgets-5.7.1:5=
	>=media-gfx/qrencode-3.4.4-r1"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}"/${PN}-cxx14.patch)

DOCS=(
	README.md
	Example-client-configuration-file.ini
	Example-contacts-file.txt
)

src_configure() {
	local mycmakeargs=(
		# set version manually, since autodetection works only with git
		"-DOPENMITTSU_CUSTOM_VERSION_STRING=${PV%.*}-${PV##*.}-00000000"
		"-DOPENMITTSU_DISABLE_VERSION_UPDATE_CHECK=ON"
	)
	cmake-utils_src_configure
}

src_install() {
	local my_pn="openMittsu"
	cmake-utils_src_install
	newicon resources/icon.png ${my_pn}.png
	make_desktop_entry ${my_pn} ${my_pn} ${my_pn}
	rm "${ED}"/usr/bin/${my_pn}VersionInfo || die
}
