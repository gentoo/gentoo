# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit meson

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${P}/${PN}-${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
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

# Most of the testuiste cannot run in our sandboxed environment, just don't
# deal with it for now.
RESTRICT="test"

S=${WORKDIR}/${PN}-${P}

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	find "${ED}"/usr -name 'lib*.la' -delete
}
