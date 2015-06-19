# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mdds/mdds-0.11.2-r1.ebuild,v 1.1 2015/02/08 00:23:40 polynomial-c Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="http://code.google.com/p/multidimalgorithm/"
SRC_URI="http://kohei.us/files/${PN}/src/${P/-/_}.tar.bz2"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/-/_}

src_prepare() {
	epatch "${FILESDIR}/${P}-include_algorithm_unconditionally.patch"
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
