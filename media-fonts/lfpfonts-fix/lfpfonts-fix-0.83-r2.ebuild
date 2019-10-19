# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Linux Font Project fixed-width fonts"
SRC_URI="mirror://sourceforge/xfonts/${PN}-src-${PV}.tar.bz2"
HOMEPAGE="https://sourceforge.net/projects/xfonts/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${PN}-src"

PATCHES=( "${FILESDIR}"/${PN}-0.83-noglyph.patch )

DOCS="doc/*"
FONT_S="${S}/src"

src_prepare() {
	default
	sed -i -e '/^FONT /s/\(.*-\)C*-/\1C-/' src/*.bdf || die
}

src_compile() {
	cd "${FONT_S}" || die
	font-ebdftopcf_src_compile
}
