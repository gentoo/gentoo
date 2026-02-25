# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

DESCRIPTION="uEmacs/PK is an enhanced version of MicroEMACS"
HOMEPAGE="https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git"
# snapshot from git repo
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/uemacs-${PV}.tar.xz"
S="${WORKDIR}/uemacs"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="app-text/hunspell:=
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=("${FILESDIR}"/${PN}-4.0.15_p20260224-gentoo.patch)

src_compile() {
	emake V=1 \
		CC="$(tc-getCC)" \
		MY_CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin em
	insinto /usr/share/${PN}
	doins emacs.hlp
	newins emacs.rc .emacsrc
	dodoc README readme.39e emacs.ps UTF-8-demo.txt
}
