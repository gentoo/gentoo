# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

RELDATE="2011-03-07"
RELEASE="${PN}-v${PV}-${RELDATE}"

DESCRIPTION="Clustering Database at High Identity with Tolerance"
HOMEPAGE="http://weizhong-lab.ucsd.edu/cd-hit/"
SRC_URI="https://cdhit.googlecode.com/files/${RELEASE}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="openmp"

S="${WORKDIR}"/${RELEASE}

pkg_setup() {
	 use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare() {
	tc-export CXX
	use openmp || append-flags -DNO_OPENMP
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	local myconf=
	use openmp && myconf="openmp=yes"
	emake ${myconf}
}

src_install() {
	dodir /usr/bin
	emake PREFIX="${ED}/usr/bin" install
	dodoc ChangeLog cdhit-user-guide.pdf
}
