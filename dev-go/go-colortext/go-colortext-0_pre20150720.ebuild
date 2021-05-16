# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN="github.com/daviddengcn/go-colortext"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT=3b18c85
	ARCHIVE_URI="https://github.com/daviddengcn/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Change the console foreground and background colors"
HOMEPAGE="https://github.com/daviddengcn/go-colortext"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	golang-build_src_install
dodoc src/${EGO_PN}/*.md
}
