# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-build golang-vcs-snapshot

EGO_SRC=git.torproject.org/pluggable-transports/goptlib.git
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="${PV}"

DESCRIPTION="Go Tor pluggable transports library"
HOMEPAGE="https://gitweb.torproject.org/pluggable-transports/goptlib.git"
# No official tarballs; see https://trac.torproject.org/projects/tor/ticket/18504
SRC_URI="mirror://debian/pool/main/g/golang-${PN}/golang-${P/-/_}.orig.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="CC0-1.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
