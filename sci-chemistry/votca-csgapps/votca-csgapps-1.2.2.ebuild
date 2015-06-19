# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/votca-csgapps/votca-csgapps-1.2.2.ebuild,v 1.7 2012/12/26 23:25:25 ottxor Exp $

EAPI=4

inherit cmake-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
	RESTRICT="primaryuri"
else
	inherit mercurial
	EHG_REPO_URI="https://csgapps.votca.googlecode.com/hg"
fi

DESCRIPTION="Extra applications for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-macos"
IUSE=""

RDEPEND="=sci-chemistry/${PN%apps}-${PV}"

DEPEND="${RDEPEND}"

DOCS=( README )

PATCHES=( "${FILESDIR}/${P}-dso.patch" )
