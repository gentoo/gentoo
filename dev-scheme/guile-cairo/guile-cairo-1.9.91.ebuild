# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="Wraps the Cairo graphics library for Guile Scheme"
HOMEPAGE="http://www.nongnu.org/guile-cairo/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs test"

RDEPEND="
	>=dev-scheme/guile-1.8
	>=x11-libs/cairo-1.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-scheme/guile-lib )"

src_configure() {
	local myeconfargs=( --disable-Werror )
	autotools-utils_src_configure
}
