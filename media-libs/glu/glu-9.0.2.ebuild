# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/glu.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit meson-multilib ${GIT_ECLASS}

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="https://mesa.freedesktop.org/archive/glu/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="SGI-B-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND=">=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-9.0.2-clang-16-register.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dgl_provider=glvnd
	)
	meson_src_configure
}
