# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	MY_P="${PN}-${P}"
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${P}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
# Most of the testsuite cannot run in our sandboxed environment, just don't
# deal with it for now.
RESTRICT="!test? ( test ) test"

RDEPEND="
	>=x11-libs/libdrm-2.4.121
	media-libs/libepoxy
"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"

src_configure() {
	local emesonargs=(
		# TODO: Wire up drm-renderers= (msm, amdgpu-experimental as of 1.1.1)
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_use test tests)
	)

	meson_src_configure
}
