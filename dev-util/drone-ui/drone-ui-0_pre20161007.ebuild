# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/drone/drone-ui/..."
EGIT_COMMIT="9913c868839e709599f3ed659c3e0a137a2e2706"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="React front-end for the Drone continuous integration server"
HOMEPAGE="https://github.com/drone/drone-ui"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-go/go-bindata-assetfs"
