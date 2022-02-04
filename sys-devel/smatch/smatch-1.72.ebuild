# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://repo.or.cz/${PN}.git
		https://repo.or.cz/r/${PN}.git"
	inherit git-r3
else
	SRC_URI="http://repo.or.cz/w/smatch.git/snapshot/${PV}.tar.gz -> ${P}.tar.gz
		mirror://gentoo/${P}.tar.gz"
	# Update on bumps
	S="${WORKDIR}"/${P}-7f4b936

	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

DESCRIPTION="Static analysis tool for C"
HOMEPAGE="http://smatch.sourceforge.net/"

LICENSE="OSL-1.1"
SLOT="0"

RDEPEND="dev-db/sqlite"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS =/{s:=:+=:;s:-O2 -finline-functions:${CPPFLAGS}:}' \
		-e 's:pkg-config:$(PKG_CONFIG):' \
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
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
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
