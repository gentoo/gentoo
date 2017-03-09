# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/plouc/go-gitlab-client/..."
EGIT_COMMIT="a526ef09e9e03f673a43ecd4a687abf6c25343ca"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A simple gitlab api client written in Go"
HOMEPAGE="https://github.com/plouc/go-gitlab-client"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""

# Requires dev-go/testify to be packaged
RESTRICT="test"
