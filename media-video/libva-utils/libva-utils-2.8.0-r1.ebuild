# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
fi

if [[ ${PV} = 2.8.0 ]]; then
	AUTOCONFIGURED="true"
else
	AUTOCONFIGURED="false"
fi

if ! ${AUTOCONFIGURED}; then
	inherit autotools
fi

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [[ ${PV} != *9999* ]] ; then
	if ${AUTOCONFIGURED}; then
		SRC_URI="https://github.com/intel/libva-utils/releases/download/${PV}/${P}.tar.bz2"
	else
		SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
	fi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
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
	>=x11-libs/libva-${PV}:=[drm?,wayland?,X?]
	wayland? ( >=dev-libs/wayland-1.0.6 )
	X? ( >=x11-libs/libX11-1.6.2 )
"
RDEPEND="${DEPEND}"

DOCS=( NEWS )

src_prepare() {
	default
	sed -e 's/-Werror//' -i test/Makefile.am || die
	if ${AUTOCONFIGURED}; then
		sed -e 's/-Werror//' -i test/Makefile.in || die
		touch ./configure || die
	else
		eautoreconf
	fi
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
