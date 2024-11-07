# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt GUI Pulseaudio Mixer"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.1.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-6.6:6[gui,widgets]
	media-libs/libpulse[glib]
"
RDEPEND="${DEPEND}"
