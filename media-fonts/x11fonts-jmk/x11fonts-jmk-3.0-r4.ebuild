# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font toolchain-funcs

MY_P="jmk-x11-fonts-${PV}"

DESCRIPTION="This package contains character-cell fonts for use with X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~loong ppc ~s390 sparc x86"

BDEPEND="
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1
	>=x11-apps/mkfontscale-1.2.0
	x11-apps/bdftopcf"

PATCHES=(
	"${FILESDIR}"/gzip.patch
)

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_install() {
	emake install INSTALL_DIR="${ED}/usr/share/fonts/jmk"
	einstalldocs
}
