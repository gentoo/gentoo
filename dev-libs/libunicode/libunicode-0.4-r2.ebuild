# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Unicode library"
HOMEPAGE="https://www.gnome.org/"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.gnome.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ppc ~sparc x86"
IUSE=""

src_prepare() {
	default
	# The build system is too old, regenerate here to fix crossbuild and
	# respect LDFLAGS and probably other problems too.
	sed -i -e "/testsuite/d" configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static libs installed
	find "${D}" -name '*.la' -delete || die
}
