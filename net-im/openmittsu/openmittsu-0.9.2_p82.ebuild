# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

MY_PN="openMittsu"
DESCRIPTION="An open source chat client for Threema-style end-to-end encrypted chat networks"
HOMEPAGE="https://www.openmittsu.de/"
# git-archive-all.sh snapshot of https://github.com/blizzard4591/${MY_PN}.git
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2+ BitstreamVera OFL-1.1 Apache-2.0 CC0-1.0 MIT BSD-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libsodium-1.0.11:=
	>=dev-qt/qtcore-5.7.1:5=
	>=dev-qt/qtgui-5.7.1:5=
	>=dev-qt/qtmultimedia-5.7.1:5=
	>=dev-qt/qtnetwork-5.7.1:5=
	>=dev-qt/qtwidgets-5.7.1:5=
	>=media-gfx/qrencode-3.4.4-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=(
	README.md
	Example-client-configuration-file.ini
	Example-contacts-file.txt
)

src_prepare() {
	# set version manually, since autodetection works only with git
	sed -i "/git_describe_checkout/\
		s/.*/set(OPENMITTSU_GIT_VERSION_STRING \"${PV/_p/-}-00000000\")/" \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=("-DOPENMITTSU_DISABLE_VERSION_UPDATE_CHECK=ON")
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon resources/icon.png ${MY_PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN}
}
