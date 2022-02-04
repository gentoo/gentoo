# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-configtool"
fi

DESCRIPTION="GTK+ GUI configuration tool for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-configtool"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="4"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE=""

BDEPEND="dev-libs/glib:2
	virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	app-text/iso-codes
	dev-libs/glib:2
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DENABLE_GTK2=OFF
		-DENABLE_GTK3=ON
	)

	cmake_src_configure
}
