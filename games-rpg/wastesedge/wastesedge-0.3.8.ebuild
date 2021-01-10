# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools python-single-r1 xdg

DESCRIPTION="Role playing game to showcase the adonthell engine"
HOMEPAGE="http://adonthell.nongnu.org/download/"
SRC_URI="https://savannah.nongnu.org/download/adonthell/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=games-rpg/adonthell-0.3.8[${PYTHON_SINGLE_USEDEP}]
	nls? ( virtual/libintl )"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}/${P}_version-handling.patch" )
DOCS=( AUTHORS ChangeLog NEWS PLAYING README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-adonthell-binary="/usr/bin/adonthell"
}
