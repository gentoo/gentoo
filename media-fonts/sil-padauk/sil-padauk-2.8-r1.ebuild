# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_PN="padauk"

DESCRIPTION="SIL fonts for Myanmar script"
HOMEPAGE="http://scripts.sil.org/padauk"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_S="${WORKDIR}/${MY_PN}-2.80"
S="${FONT_S}"

FONT_SUFFIX="ttf"
