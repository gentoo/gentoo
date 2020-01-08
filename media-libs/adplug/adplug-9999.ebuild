# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit out-of-source

DESCRIPTION="A free, cross-platform, hardware independent AdLib sound player library"
HOMEPAGE="http://adplug.github.io/"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/adplug/adplug.git"
else
	SRC_URI="https://github.com/adplug/${PN}/releases/download/${P}/${P}.tar.bz2"
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

my_src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug)
}

my_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
