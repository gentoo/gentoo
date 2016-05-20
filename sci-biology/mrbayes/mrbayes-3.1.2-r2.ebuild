# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Bayesian Inference of Phylogeny"
HOMEPAGE="http://mrbayes.csit.fsu.edu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="debug mpi readline"

DEPEND="
	sys-libs/ncurses:0=
	mpi? ( virtual/mpi )
	readline? ( sys-libs/readline:0= )"
RDEPEND="${DEPEND}"

src_prepare() {
	if use mpi; then
		sed -e "s:MPI ?= no:MPI=yes:" -i Makefile || die "Patching MPI support."
	fi
	if ! use readline; then
		sed -e "s:USEREADLINE ?= yes:USEREADLINE=no:" \
			-i Makefile || die "Patching readline support."
	else
		# Only needed for OSX with an old (4.x) version of
		# libreadline, but it doesn't hurt for other distributions.
		epatch "${FILESDIR}"/mb_readline_312.patch
	fi
	sed -e 's:-ggdb::g' -i Makefile || die
}

src_compile() {
	local myconf mycc

	if use mpi; then
		mycc=mpicc
	else
		mycc=$(tc-getCC)
	fi

	use mpi && myconf="MPI=yes"
	use readline || myconf="${myconf} USEREADLINE=no"
	use debug && myconf="${myconf} DEBUG=yes"
	emake \
		OPTFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC=${mycc} \
		${myconf}
}

src_install() {
	dobin mb
	insinto /usr/share/${PN}
	doins *.nex
}
