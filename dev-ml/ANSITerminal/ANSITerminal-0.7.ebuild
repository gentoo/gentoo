# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis eutils

DESCRIPTION="Module which offers basic control of ANSI compliant terminals"
HOMEPAGE="https://github.com/Chris00/ANSITerminal"
SRC_URI="https://github.com/Chris00/ANSITerminal/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
RDEPEND=""
DEPEND="${DEPEND} dev-ml/oasis"
IUSE=""

DOCS=( "README.txt" "AUTHORS.txt" )

src_prepare() {
	epatch "${FILESDIR}/oasis.patch"
	oasis setup || die
}
