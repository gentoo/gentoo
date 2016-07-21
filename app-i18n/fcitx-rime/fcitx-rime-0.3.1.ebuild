# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

DESCRIPTION="Rime support for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8.1[dbus]
	>=app-i18n/librime-1.0
	app-i18n/rime-data"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# dont build data resource here, already provided by app-i18n/rime-data
	sed -i -e 's|add_subdirectory(data)||' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DRIME_DATA_DIR=/usr/share/rime-data
	)
	cmake-utils_src_configure
}
