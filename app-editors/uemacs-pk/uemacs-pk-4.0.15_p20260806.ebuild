# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

if [[ ${PV##*.} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
else
	# git archive --prefix=${PN}/ HEAD | xz > ${P}.tar.xz
	SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.tar.xz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

DESCRIPTION="uEmacs/PK is an enhanced version of MicroEMACS"
HOMEPAGE="https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git"
S="${WORKDIR}/${PN}"

LICENSE="free-noncomm"
SLOT="0"
IUSE="hunspell"

RDEPEND="sys-libs/ncurses:0=
	hunspell? ( app-text/hunspell:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=("${FILESDIR}"/${PN}-4.0.15_p20260806-gentoo.patch)

src_compile() {
	emake V=1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		HUNSPELL="$(usex hunspell 1 0)"
}

src_install() {
	dobin em
	insinto /usr/share/${PN}
	doins emacs.hlp
	newins emacs.rc .emacsrc
	dodoc README readme.39e emacs.ps UTF-8-demo.txt
}
