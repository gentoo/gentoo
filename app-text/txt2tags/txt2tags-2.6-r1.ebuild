# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk?"

inherit eutils elisp-common python-single-r1

DESCRIPTION="Generate marked up documents (HTML, etc.)from a plain text file with markup"
HOMEPAGE="https://txt2tags.org"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="emacs tk vim-syntax"

DEPEND="${PYTHON_DEPS}
	tk? ( dev-lang/tk )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
	emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

SITEFILE="51${PN}-gentoo.el"

src_compile() {
	if use emacs; then
		elisp-compile extras/txt2tags-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	dobin txt2tags

	dodoc README ChangeLog*
	dodoc doc/*.{pdf,t2t}
	dodoc -r samples extras
	newman doc/manpage.man txt2tags.1

	# make .po files
	for pofile in "${S}"/po/*.po; do
		msgfmt -o ${pofile%%.po}.mo ${pofile}
	done
	domo po/*.mo

	# emacs support
	if use emacs; then
		elisp-install ${PN} extras/txt2tags-mode.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins extras/txt2tags.vim || die

		echo 'au BufNewFile,BufRead *.t2t set ft=txt2tags' > "${T}/${PN}.vim"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${T}/${PN}.vim" || die
	fi

	python_fix_shebang "${D}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
