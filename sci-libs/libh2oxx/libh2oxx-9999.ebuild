# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit git-r3
#endif

inherit autotools-utils

DESCRIPTION="C++ bindings for libh2o"
HOMEPAGE="https://bitbucket.org/mgorny/libh2oxx/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

RDEPEND=">=sci-libs/libh2o-0.2:0="
DEPEND="${RDEPEND}"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)

	autotools-utils_src_configure
}
