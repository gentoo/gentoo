# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_SRC=github.com/agl/ed25519
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="5312a61534124124185d41f09206b9fef1d88403"

DESCRIPTION="ed25519 for Go"
HOMEPAGE="https://github.com/agl/ed25519/"
SRC_URI="https://github.com/agl/ed25519/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-go/go-crypto )"
RDEPEND=""
