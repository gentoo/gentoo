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
IUSE=""

RDEPEND="
	!media-libs/mesa[-libglvnd(-)]
	!<media-libs/mesa-19.2.0_rc1
	x11-libs/libX11[${MULTILIB_USEDEP}]
	"
DEPEND="${PYTHON_DEPS}
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Add-pkg-config-files-for-EGL-GL-GLES-and-GLX.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

multilib_src_test() {
	emake check
}
