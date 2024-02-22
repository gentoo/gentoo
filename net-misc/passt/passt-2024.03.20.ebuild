# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-mode networking daemons for VMs and namespaces, replacement for Slirp"
HOMEPAGE="https://passt.top/"

RELEASE_COMMIT="71dd405"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://passt.top/passt"
else
	SRC_URI="https://passt.top/passt/snapshot/passt-${RELEASE_COMMIT}.tar.xz -> ${P}.tar.xz"
	S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="static"

PATCHES=(
	"${FILESDIR}"/Makefile-2024.03.20.patch
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	[[ ${PV} != 9999* ]] && export VERSION="${PV}"
	export prefix="${EPREFIX}/usr" docdir="${EPREFIX}/usr/share/doc/${P}"

	emake $(usev static)
}
