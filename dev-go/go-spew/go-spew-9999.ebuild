# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-spew/go-spew-9999.ebuild,v 1.3 2015/08/05 17:41:50 williamh Exp $

EAPI=5

EGO_SRC=github.com/davecgh/${PN}
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="2df174808ee097f90d259e432cc04442cf60be21"
	SRC_URI="https://${EGO_SRC}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Implements a deep pretty printer for Go data structures to aid in debugging"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="ISC"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""
