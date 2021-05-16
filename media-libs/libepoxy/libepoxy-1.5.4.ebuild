# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='xml(+)'
inherit meson multilib-minimal python-any-r1

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/anholt/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/anholt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Library for handling OpenGL function pointer management"
HOMEPAGE="https://github.com/anholt/libepoxy"

LICENSE="MIT"
SLOT="0"
IUSE="+egl test +X"

RESTRICT="!test? ( test )"

RDEPEND="
	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

multilib_src_configure() {
	local emesonargs=(
		-Degl=$(usex egl)
		-Dglx=$(usex X)
		$(meson_use X x11)
		$(meson_use test tests)
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
