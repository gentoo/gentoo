# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit subversion

ESVN_REPO_URI="https://svn.cv.nrao.edu/svn/casa-data/distro@${PV}"
ESVN_OPTIONS="--non-interactive --trust-server-cert "

DESCRIPTION="Data and tables for the CASA software"
HOMEPAGE="https://safe.nrao.edu/wiki/bin/view/Software/ObtainingCasaDataRepository"
SRC_URI=""

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/distro"

src_install(){
	insinto /usr/share/casa/data
	doins -r *
}
