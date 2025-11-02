# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/virgl/virglrenderer.git"
	inherit git-r3
else
	MY_P="${PN}-${P}"
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${P}/${MY_P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

RDEPEND="
	>=x11-libs/libdrm-2.4.50
	media-libs/libepoxy"

DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

# Most of the testsuite cannot run in our sandboxed environment, just don't
# deal with it for now.
RESTRICT="test"

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	find "${ED}/usr" -name 'lib*.la' -delete || die
}
