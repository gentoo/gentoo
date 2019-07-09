# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_SRC=git.torproject.org/pluggable-transports/goptlib.git
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="${PV}"

DESCRIPTION="Go Tor pluggable transports library"
HOMEPAGE="https://gitweb.torproject.org/pluggable-transports/goptlib.git"
# Upstream does not publish release tarballs
SRC_URI="https://dev.gentoo.org/~marecki/dists/${PN}/${P}.tar.xz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="CC0-1.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
