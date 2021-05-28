# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit autotools multilib-minimal

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~sparc x86"

DEPEND="virtual/opengl"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-shared-libs.patch
	"${FILESDIR}"/${P}-X11-r1.patch
	"${FILESDIR}"/${P}-CVE-2011-4620.patch
	"${FILESDIR}"/${P}-CVE-2012-4552.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		--enable-shared
	)
	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install_all() {
	DOCS=( AUTHORS ChangeLog KNOWN_BUGS NOTICE README* TODO* )
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
