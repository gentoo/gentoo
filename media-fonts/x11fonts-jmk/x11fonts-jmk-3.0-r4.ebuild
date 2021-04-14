# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font toolchain-funcs

MY_P="jmk-x11-fonts-${PV}"

DESCRIPTION="This package contains character-cell fonts for use with X"
HOMEPAGE="http://www.jmknoble.net/fonts/"
SRC_URI="http://www.pobox.com/~jmknoble/fonts/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ~s390 sparc x86"

BDEPEND="
	>=x11-misc/imake-1.0.8-r1
	>=x11-apps/mkfontscale-1.2.0
	x11-apps/bdftopcf"

DOCS=( "ChangeLog" "NEWS" "README" )

PATCHES=( "${FILESDIR}"/gzip.patch )

S="${WORKDIR}/${MY_P}"

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf || die
}

src_install() {
	emake install INSTALL_DIR="${ED}/usr/share/fonts/jmk"
	einstalldocs
}
