# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/codegangsta/cli/..."
EGIT_COMMIT="a2943485b110df8842045ae0600047f88a3a56a1"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A small package for building command line apps in Go"
HOMEPAGE="https://github.com/codegangsta/cli"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""
