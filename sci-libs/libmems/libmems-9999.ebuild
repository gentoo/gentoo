# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools subversion

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
ESVN_REPO_URI="https://svn.code.sf.net/p/mauve/code/libMems/trunk"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc"

RDEPEND="
	dev-libs/boost:=
	sci-libs/libgenome
	sci-libs/libmuscle
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}"

src_prepare() {
	default
	eautoreconf
}
