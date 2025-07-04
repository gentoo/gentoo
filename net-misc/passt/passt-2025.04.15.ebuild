# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-mode networking daemons for VMs and namespaces, replacement for Slirp"
HOMEPAGE="https://passt.top/"

RELEASE_COMMIT="2340bbf"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://passt.top/passt"
else
	SRC_URI="https://passt.top/passt/snapshot/passt-${RELEASE_COMMIT}.tar.xz -> ${P}.tar.xz"
	S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"
	KEYWORDS="amd64 arm64 ~loong ~riscv"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="static"

src_prepare() {
	default
	tc-export CC
	# Do not install doc/demo.sh
	sed -i -e "/demo/d" Makefile || die
}

src_compile() {
	[[ ${PV} != 9999* ]] && export VERSION="${PV}"
	export prefix="${EPREFIX}/usr" docdir="${EPREFIX}/usr/share/doc/${P}"

	emake $(usev static)
}
