# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]] ; then # Live ebuild
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
fi
inherit autotools

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [[ ${PV} != *9999* ]] ; then
	SRC_URI="https://github.com/intel/libva-utils/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+drm test wayland X"
RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( drm wayland X )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=x11-libs/libva-2.0.0:=[drm?,wayland?,X?]
	drm? ( >=x11-libs/libdrm-2.4 )
	wayland? ( >=dev-libs/wayland-1.0.6 )
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXfixes-5.0.1
	)
"
RDEPEND="${DEPEND}"

DOCS=( NEWS )

src_prepare() {
	default
	sed -e 's/-Werror//' -i test/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable drm)
		$(use_enable test tests)
		$(use_enable wayland)
		$(use_enable X x11)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	[[ ${PV} = *9999* ]] && DOCS+=( CONTRIBUTING.md README.md )
	default
}
