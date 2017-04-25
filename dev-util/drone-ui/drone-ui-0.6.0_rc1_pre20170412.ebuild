# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/drone/drone-ui/..."
COMMIT="d8426a1658a71c0dd0c7a0aa6f5cc072e3328f9e"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="React front-end for the Drone continuous integration server"
HOMEPAGE="https://github.com/drone/drone-ui"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-go/go-bindata-assetfs"

RESTRICT="test"
