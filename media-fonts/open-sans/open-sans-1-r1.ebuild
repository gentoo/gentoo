# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Clean and modern sans-serif typeface designed for legibility across interfaces"
HOMEPAGE="https://www.opensans.com/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.zip"
# renamed from unversioned google zip
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
