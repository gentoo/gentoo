# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool that prints the cwd of the currently focused window."
HOMEPAGE="https://github.com/schischi/xcwd"
GIT_COMMIT="99738e1176acf3f39c2e709236c3fd87b806f2ed"
SRC_URI="https://github.com/schischi/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	${DEPEND}
	virtual/pkgconfig
"
src_install() {
	mkdir -p "${D}"/usr/bin
	emake prefix="${D}"/usr install
}
