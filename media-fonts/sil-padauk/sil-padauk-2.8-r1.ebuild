# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="padauk"
inherit font

DESCRIPTION="SIL fonts for Myanmar script"
HOMEPAGE="http://scripts.sil.org/padauk"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.zip"
S="${WORKDIR}/${MY_PN}-2.80"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE=""

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
