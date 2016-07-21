# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="GUI frontend to the Subversion revision system"
HOMEPAGE="http://www.anrichter.net/projects/qsvn/"
SRC_URI="http://www.anrichter.net/projects/${PN}/chrome/site/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/apr
	dev-libs/apr-util
	dev-vcs/subversion
	dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4[qt3support]
	dev-qt/qtsql:4[sqlite]
	dev-vcs/subversion"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/src

PATCHES=(
	"${FILESDIR}/${P}-static-lib.patch"
	"${FILESDIR}/${P}-tests.patch"
)

DOCS=( ../ChangeLog ../README )
