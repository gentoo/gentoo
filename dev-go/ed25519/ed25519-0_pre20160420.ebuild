# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-build golang-vcs-snapshot

EGO_SRC=github.com/agl/ed25519
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="278e1ec8e8a6e017cd07577924d6766039146ced"

DESCRIPTION="ed25519 for Go"
HOMEPAGE="https://github.com/agl/ed25519/"
SRC_URI="https://github.com/agl/ed25519/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
