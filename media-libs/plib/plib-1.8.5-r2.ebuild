# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit flag-o-matic autotools

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND="virtual/opengl"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-X11-r1.patch
	"${FILESDIR}"/${P}-CVE-2011-4620.patch
	"${FILESDIR}"/${P}-CVE-2012-4552.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die

	eautoreconf

	# Since plib only provides static libraries, force
	# building as PIC or plib is useless to amd64/etc...
	append-flags -fPIC
}

src_install() {
	DOCS=( AUTHORS ChangeLog KNOWN_BUGS NOTICE README* TODO* )

	default
}
