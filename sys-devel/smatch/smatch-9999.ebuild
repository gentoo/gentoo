# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git
		http://repo.or.cz/r/${PN}.git"
	inherit git-2
else
	SRC_URI="http://repo.or.cz/w/smatch.git/snapshot/${PV}.tar.gz -> ${P}.tar.gz
		mirror://gentoo/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="static analysis tool for C"
HOMEPAGE="http://smatch.sourceforge.net/"

LICENSE="OSL-1.1"
SLOT="0"
IUSE=""

RDEPEND="dev-db/sqlite"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e '/^CFLAGS =/{s:=:+=:;s:-O2 -finline-functions:${CPPFLAGS}:}' \
		Makefile || die
}

_emake() {
	# gtk/llvm/xml is used by sparse which we don't install
	emake \
		PREFIX="${EPREFIX}/usr" \
		V=1 \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LD='$(CC)' \
		HAVE_GTK2=no \
		HAVE_LLVM=no \
		HAVE_LIBXML=no \
		"$@"
}

src_compile() {
	_emake smatch
}

src_test() {
	_emake check
}

src_install() {
	# default install target installs a lot of sparse cruft
	dobin smatch
	insinto /usr/share/smatch/smatch_data
	doins smatch_data/*
	dodoc FAQ README
}
