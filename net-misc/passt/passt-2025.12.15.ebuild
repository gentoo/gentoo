# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-mode networking daemons for VMs and namespaces, replacement for Slirp"
HOMEPAGE="https://passt.top/"

RELEASE_COMMIT="b40f5cd"
MY_PV=${P//./_}.${RELEASE_COMMIT}

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://passt.top/passt"
else
	SRC_URI="https://passt.top/passt/snapshot/${MY_PV}.tar.xz -> ${P}.tar.xz"
	S=${WORKDIR}/${MY_PV}
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
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
