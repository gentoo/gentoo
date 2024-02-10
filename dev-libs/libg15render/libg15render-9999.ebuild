# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Small library for display text and graphics on a Logitech G15 keyboard"
HOMEPAGE="https://gitlab.com/menelkir/libg15render"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/menelkir/libg15render.git"
else
	SRC_URI="https://gitlab.com/menelkir/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="truetype"

RDEPEND="
	>=dev-libs/libg15-3.0
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}"
BDEPEND="
	truetype? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-docdir.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype ttf)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -type f -name '*.la' -delete || die
}
