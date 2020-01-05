# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/glvnd/libglvnd.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python3_{6,7,8} )
VIRTUALX_REQUIRED=manual

inherit ${GIT_ECLASS} meson multilib-minimal python-any-r1 virtualx

DESCRIPTION="The GL Vendor-Neutral Dispatch library"
HOMEPAGE="https://gitlab.freedesktop.org/glvnd/libglvnd"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://gitlab.freedesktop.org/glvnd/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
	S=${WORKDIR}/${PN}-v${PV}
fi

LICENSE="MIT"
SLOT="0"
IUSE="test X"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	test? ( X? ( ${VIRTUALX_DEPEND} ) )"
RDEPEND="
	!media-libs/mesa[-libglvnd(-)]
	!<media-libs/mesa-19.2.2
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-meson-Fix-the-armv7-build.patch
	"${FILESDIR}"/${P}-meson-Fix-the-PPC64-build.patch
)

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature X glx)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	if use X; then
		virtx meson_src_test
	else
		meson_src_test
	fi
}

multilib_src_install() {
	meson_src_install
}
