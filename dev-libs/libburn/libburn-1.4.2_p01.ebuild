# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PV="${PV/_p01/.pl01}"

DESCRIPTION="Open-source library for reading, mastering and writing optical discs"
HOMEPAGE="http://libburnia-project.org"
SRC_URI="http://files.libburnia-project.org/releases/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cdio debug static-libs track-src-odirect"

RDEPEND="cdio? ( >=dev-libs/libcdio-0.83 )"
DEPEND="$RDEPEND
	virtual/pkgconfig"

S="${WORKDIR}/${P%_p01}"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable track-src-odirect) \
	--enable-pkg-check-modules \
	$(use_enable cdio libcdio) \
	--disable-ldconfig-at-install \
	$(use_enable debug)
}

src_install() {
	default

	dodoc CONTRIBUTORS doc/{comments,*.txt}

	docinto cdrskin
	dodoc cdrskin/{*.txt,README}
	docinto cdrskin/html
	dohtml cdrskin/cdrskin_eng.html

	prune_libtool_files --all
}
