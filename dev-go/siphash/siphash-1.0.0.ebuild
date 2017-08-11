# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

EGO_SRC=github.com/dchest/siphash
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="v${PV}"
SRC_URI="https://github.com/dchest/siphash/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Go implementation of SipHash-2.4"
HOMEPAGE="https://github.com/dchest/siphash"

KEYWORDS="~amd64 arm ~x86"

LICENSE="CC0-1.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
