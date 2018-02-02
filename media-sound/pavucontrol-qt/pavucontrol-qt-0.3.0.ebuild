# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A Pulseaudio mixer in Qt (port of pavucontrol)"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libqtxdg:0/3
	media-sound/pulseaudio[glib]
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	>=lxqt-base/liblxqt-0.12.0
"
DEPEND="${RDEPEND}
	>=dev-util/lxqt-build-tools-0.4.0
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
