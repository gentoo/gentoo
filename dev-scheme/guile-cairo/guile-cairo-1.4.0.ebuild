# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Wraps the Cairo graphics library for Guile Scheme"
HOMEPAGE="http://home.gna.org/guile-cairo/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="test"

RDEPEND=">=dev-scheme/guile-1.8
	>=x11-libs/cairo-1.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-scheme/guile-lib )"

src_configure() {
	econf --disable-Werror
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog || die "dodoc failed"
}
