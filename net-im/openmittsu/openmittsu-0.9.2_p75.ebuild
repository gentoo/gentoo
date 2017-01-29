# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

MY_P="openMittsu-${PV}"
DESCRIPTION="An open source chat client for Threema-style end-to-end encrypted chat networks"
HOMEPAGE="https://github.com/blizzard4591/openMittsu"
# git-archive-all.sh snapshot of https://github.com/blizzard4591/openMittsu.git
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${MY_P}.tar.xz"

LICENSE="GPL-2+ BitstreamVera OFL-1.1 Apache-2.0 CC0-1.0 MIT"
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

S="${WORKDIR}/${MY_P}"
PATCHES=("${FILESDIR}/${P}-libsodium-so.patch")
MYCMAKEARGS="-DOPENMITTSU_DISABLE_VERSION_UPDATE_CHECK=ON"

DOCS="README.md
	Example-client-configuration-file.ini
	Example-contacts-file.txt"

src_prepare() {
	# set version manually, since autodetection works only with git
	sed -i "/git_describe_checkout/\
		s/.*/set(OPENMITTSU_GIT_VERSION_STRING \"${PV/_p/-}-00000000\")/" \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}
