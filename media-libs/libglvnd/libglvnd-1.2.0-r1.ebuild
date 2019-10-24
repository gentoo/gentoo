# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/NVIDIA/${PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
inherit autotools ${GIT_ECLASS} multilib-minimal python-any-r1

DESCRIPTION="The GL Vendor-Neutral Dispatch library"
HOMEPAGE="https://github.com/NVIDIA/libglvnd"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/NVIDIA/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="X"

RDEPEND="
	!media-libs/mesa[-libglvnd(-)]
	!<media-libs/mesa-19.2.2
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)"
DEPEND="${PYTHON_DEPS}
	${RDEPEND}
	X? ( x11-base/xorg-proto )"

src_prepare() {
	default
	[[ $PV = 9999* ]] && eautoreconf
}

multilib_src_configure() {
	myconf=(
		$(use_enable X x11)
		$(use_enable X glx)
	)
	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

multilib_src_test() {
	emake check
}
