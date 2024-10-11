# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-mode networking daemons for VMs and namespaces, replacement for Slirp"
HOMEPAGE="https://passt.top/"

RELEASE_COMMIT="6b38f07"
MY_PV="${PV//./_}.${RELEASE_COMMIT}"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://passt.top/passt"
else
	SRC_URI="https://passt.top/passt/snapshot/passt-${MY_PV}.tar.xz -> ${PF}.tar.xz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="static"

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	[[ ${PV} != 9999* ]] && export VERSION="${PV}"
	export prefix="${EPREFIX}/usr" docdir="${EPREFIX}/usr/share/doc/${PF}"

	emake $(usev static)
}
