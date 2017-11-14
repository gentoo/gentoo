# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A free, cross-platform, hardware independent AdLib sound player library"
HOMEPAGE="http://adplug.sourceforge.net"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/adplug/adplug.git"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug static-libs"

RDEPEND=">=dev-cpp/libbinio-1.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
