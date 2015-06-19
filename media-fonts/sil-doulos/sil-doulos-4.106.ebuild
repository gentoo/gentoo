# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-doulos/sil-doulos-4.106.ebuild,v 1.7 2012/01/07 22:22:31 dirtyepic Exp $

inherit font

DESCRIPTION="SIL Doulos - SIL font for Roman and Cyrillic Languages"
HOMEPAGE="http://scripts.sil.org/DoulosSILfont"
SRC_URI="mirror://gentoo/DoulosSIL${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DOCS=( OFL-FAQ.txt README.txt )
FONT_SUFFIX="ttf"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/DoulosSIL"
FONT_S="${S}"

src_install() {
	font_src_install
}
