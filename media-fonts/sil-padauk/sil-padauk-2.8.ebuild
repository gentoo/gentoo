# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-padauk/sil-padauk-2.8.ebuild,v 1.2 2012/05/27 12:40:54 yngwin Exp $

EAPI="4"

inherit font

MY_PN="padauk"

DESCRIPTION="SIL fonts for Myanmar script"
HOMEPAGE="http://scripts.sil.org/padauk"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_S="${WORKDIR}/${MY_PN}-2.80"
S="${FONT_S}"

FONT_SUFFIX="ttf"
DOCS=""
