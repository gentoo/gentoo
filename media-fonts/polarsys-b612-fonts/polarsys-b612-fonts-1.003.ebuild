# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font vcs-snapshot

DESCRIPTION="Font designed for aircraft cockpit displays"
HOMEPAGE="https://b612-font.com/"
SRC_URI="https://git.polarsys.org/c/b612/b612.git/snapshot/b612-bd14fde2544566e620eab106eb8d6f2b7fb1347e.tar.bz2 -> ${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE=""

FONT_S="${S}/TTF"
FONT_SUFFIX="ttf"

DOCS=( README.md )
