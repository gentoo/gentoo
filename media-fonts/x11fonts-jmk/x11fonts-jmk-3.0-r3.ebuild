# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="jmk-x11-fonts-${PV}"

DESCRIPTION="This package contains character-cell fonts for use with X"
HOMEPAGE="http://www.jmknoble.net/fonts/"
SRC_URI="http://www.pobox.com/~jmknoble/fonts/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"

BDEPEND="
	x11-misc/imake
	>=x11-apps/mkfontscale-1.2.0
	x11-apps/bdftopcf"

PATCHES=( "${FILESDIR}"/gzip.patch )

S="${WORKDIR}/${MY_P}"

src_compile() {
	xmkmf || die
	default
}

src_install() {
	emake install INSTALL_DIR="${ED}/usr/share/fonts/jmk"
	einstalldocs
}
