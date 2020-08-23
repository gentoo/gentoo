# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 git-r3 toolchain-funcs

DESCRIPTION="program for making large letters out of ordinary text"
HOMEPAGE="http://www.figlet.org/"
EGIT_REPO_URI="https://github.com/cmatsuoka/figlet"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

src_compile() {
	emake clean
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LD="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		all
}

src_install() {
	emake \
		BINDIR="${EPREFIX}/usr/bin" \
		DESTDIR="${D}" \
		MANDIR="${EPREFIX}/usr/share/man" \
		prefix="${EPREFIX}/usr" \
		install

	doman chkfont.6 figlet.6 figlist.6 showfigfonts.6
	dodoc README figfont.txt

	newbashcomp "${FILESDIR}"/figlet.bashcomp-r1 figlet
}
