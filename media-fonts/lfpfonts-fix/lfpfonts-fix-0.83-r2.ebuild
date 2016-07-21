# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font eutils font-ebdftopcf

DESCRIPTION="Linux Font Project fixed-width fonts"
SRC_URI="mirror://sourceforge/xfonts/${PN}-src-${PV}.tar.bz2"
HOMEPAGE="http://sourceforge.net/projects/xfonts/"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${PN}-src"

FONT_S="${S}/src"

DOCS="${S}/doc/*"

# Only installs fonts
RESTRICT="strip binchecks"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${PN}-0.83-noglyph.patch
}

src_compile() {
	cd "${FONT_S}"
	sed -i -e '/^FONT /s/\(.*-\)C*-/\1C-/' *.bdf || die "sed failed"

	font-ebdftopcf_src_compile
}
