# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://gitlab.com/mdds/mdds.git"
[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"

inherit eutils toolchain-funcs ${GITECLASS}

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="https://gitlab.com/mdds/mdds"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/${PN}/src/${P/-/_}.tar.bz2"

LICENSE="MIT"
SLOT="0/${PV}"
IUSE=""

[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

[[ ${PV} == 9999 ]] || S=${WORKDIR}/${P/-/_}

src_prepare(){
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--with-hash-container=boost \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() { :; }

src_test() {
	tc-export CXX
	default
}
