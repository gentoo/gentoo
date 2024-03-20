# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common llvm.org

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE="emacs"

RDEPEND="
	!sys-devel/llvm:0
"
BDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
"

LLVM_COMPONENTS=( llvm/utils )
llvm.org_set_globals

SITEFILE="50llvm-gentoo.el"
BYTECOMPFLAGS="-L emacs"

src_compile() {
	default

	use emacs && elisp-compile emacs/*.el
}

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r vim/*/
	# some users may find it useful
	newdoc vim/README README.vim
	dodoc vim/vimrc

	if use emacs ; then
		elisp-install llvm emacs/*.{el,elc}
		elisp-make-site-file "${SITEFILE}" llvm
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
