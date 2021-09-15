# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Worldforge math library"
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/wfmath"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-fix-bashisms.patch
)

src_prepare() {
	default

	# For bashisms patch
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default
	use doc && emake -C doc docs
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc doc/html/*
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
