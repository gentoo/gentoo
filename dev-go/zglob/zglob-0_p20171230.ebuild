# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/mattn/go-zglob

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=4959821b481786922ac53e7ef25c61ae19fb7c36
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Unix-optimized file globbing and directory walking for Go"
HOMEPAGE="https://github.com/mattn/go-zglob"
LICENSE="MIT"
SLOT="0/${PVR}"
RDEPEND=""

src_compile() {
	EGO_PN="${EGO_PN}/cmd/zglob" golang-build_src_compile
}

src_install() {
	dobin zglob

	golang-build_src_install

	pushd "src/${EGO_PN}" >/dev/null || die
	einstalldocs
	popd >/dev/null || die
}
