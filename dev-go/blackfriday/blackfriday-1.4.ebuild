# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/russross/${PN}

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~arm64"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="a markdown processor implemented in Go"
HOMEPAGE="https://github.com/russross/blackfriday"
LICENSE="BSD-2"
SLOT="0"
IUSE=""
DEPEND="dev-go/sanitized-anchor-name"
RDEPEND="dev-go/sanitized-anchor-name:="
