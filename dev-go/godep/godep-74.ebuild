# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/tools/godep

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=v${PV}
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="dependency tool for go"
HOMEPAGE="https://github.com/tools/godep"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	dobin godep
dodoc src/${EGO_PN}/*.md
}
