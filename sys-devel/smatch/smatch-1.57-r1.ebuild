# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/smatch/smatch-1.57-r1.ebuild,v 1.1 2013/01/03 20:50:43 vapier Exp $

EAPI="4"

inherit multilib toolchain-funcs eutils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git
		http://repo.or.cz/r/${PN}.git"
	inherit git-2
fi

DESCRIPTION="static analysis tool for C"
HOMEPAGE="http://smatch.sourceforge.net/"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	#KEYWORDS=""
else
	# The repo.or.cz site does not produce stable tarballs,
	# so we have to cache our own copy of the snapshot.
	#SRC_URI="http://repo.or.cz/w/smatch.git/snapshot/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI="mirror://gentoo/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="OSL-1.1"
SLOT="0"
IUSE=""

RDEPEND="dev-db/sqlite"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-restrict.patch
	sed -i \
		-e '/^PREFIX=/s:=.*:=/usr:' \
		-e '/^CFLAGS =/{s:=:+=:;s:-O2 -finline-functions:${CPPFLAGS}:}' \
		Makefile || die
}

src_compile() {
	emake PREFIX=/usr V=1 CC="$(tc-getCC)" smatch
}

src_install() {
	# default install target installs a lot of sparse cruft
	dobin smatch
	insinto /usr/share/smatch/smatch_data
	doins smatch_data/*
	dodoc FAQ README
}
