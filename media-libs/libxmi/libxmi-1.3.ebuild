# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C/C++ function library for rasterizing 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/libxmi/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
#mirror://gnu/${PN}/${P}.tar.gz"
# Version unbundled from plotutils

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="!<=media-libs/plotutils-2.6"
RDEPEND="${DEPEND}"
