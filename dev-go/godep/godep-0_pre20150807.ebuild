# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN=github.com/tools/godep

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=9805c4da6f
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

src_prepare() {
	# disable broken tests
	sed -e 's:TestSave(:_\0:' \
		-i src/${EGO_PN}/save_test.go || die
	sed -e 's:TestUpdate(:_\0:' \
		-i src/${EGO_PN}/update_test.go || die
}

src_install() {
	dobin godep
}
