# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Bayesian Inference of Phylogeny"
HOMEPAGE="http://mrbayes.csit.fsu.edu/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mpi readline"

DEPEND="
	sys-libs/ncurses:=
	mpi? ( virtual/mpi )
	readline? ( sys-libs/readline:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	if use mpi; then
		sed -e "s:MPI ?= no:MPI=yes:" -i Makefile || die "Patching MPI support."
	fi
	if ! use readline; then
		sed -e "s:USEREADLINE ?= yes:USEREADLINE=no:" \
			-i Makefile || die "Patching readline support."
	else
		# Only needed for OSX with an old (4.x) version of
		# libreadline, but it doesn't hurt for other distributions.
		eapply "${FILESDIR}"/mb_readline_312.patch
	fi
	sed -e 's:-ggdb::g' -i Makefile || die
}

src_compile() {
	local myconf mycc

	if use mpi; then
		mycc=mpicc
	else
		mycc="$(tc-getCC)"
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
