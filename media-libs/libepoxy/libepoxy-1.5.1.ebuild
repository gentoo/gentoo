# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/anholt/${PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='xml(+)'
inherit ${GIT_ECLASS} meson multilib-minimal python-any-r1

DESCRIPTION="Epoxy is a library for handling OpenGL function pointer management for you"
HOMEPAGE="https://github.com/anholt/libepoxy"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/anholt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test +X"

DEPEND="${PYTHON_DEPS}
	media-libs/mesa[egl,${MULTILIB_USEDEP}]
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	>=dev-util/meson-0.44.0"
RDEPEND=""

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

multilib_src_configure() {
	local emesonargs=(
		-Degl=yes
		-Dglx=$(usex X)
		-Dx11=$(usex X true false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
