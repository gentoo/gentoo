# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt configuration tool for labwc"
HOMEPAGE="https://github.com/labwc/labwc-tweaks"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/labwc/labwc-tweaks.git"
else
	SRC_URI="https://github.com/labwc/labwc-tweaks/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2 BSD"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-qt/qtbase:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-qt/qttools:6
	x11-libs/libxkbcommon
"
