# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/oyranos-cms/libxcm.git"
	inherit git-r3
else
	SRC_URI="https://github.com/oyranos-cms/${PN,,}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/${P,,}"
fi

DESCRIPTION="Reference implementation of the X Color Management specification"
HOMEPAGE="https://www.oyranos.org/libxcm/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs X"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXmu
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with X x11)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
