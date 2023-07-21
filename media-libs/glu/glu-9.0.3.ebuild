# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/glu.git"
	inherit git-r3
else
	SRC_URI="https://mesa.freedesktop.org/archive/glu/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="SGI-B-2.0"
SLOT="0"

DEPEND="media-libs/libglvnd[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=shared
		-Dgl_provider=glvnd
	)
	meson_src_configure
}
