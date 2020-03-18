# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="tag system to find an object location in various sources"
HOMEPAGE="https://www.gnu.org/software/global/global.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc emacs vim"

RDEPEND="
	sys-libs/ncurses
	emacs? ( >=app-editors/emacs-23.1:* )
	vim? ( || (
			app-editors/vim
			app-editors/gvim
		)
	)
	|| (
		dev-libs/libltdl:0
		sys-devel/libtool:2
	)"

DEPEND="${DEPEND}
	doc? (
		app-text/texi2html
		sys-apps/texinfo
	)"

SITEFILE="50gtags-gentoo.el"

PATCHES=( "${FILESDIR}/${PN}-6.2.9-tinfo.patch" )

DOCS=( AUTHORS FAQ NEWS README THANKS )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		"$(use_with emacs lispdir "${SITELISP}/${PN}")"
}

src_compile() {
	if use doc; then
		texi2pdf -q -o doc/global.pdf doc/global.texi
		texi2html -o doc/global.html doc/global.texi
	fi

	if use emacs; then
		elisp-compile *.el
	fi

	emake
}

src_install() {
	default

	insinto /etc
	doins gtags.conf

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins gtags.vim
	fi

	if use emacs; then
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use doc; then
		# doc/global.pdf is generated if tex executable (e.g. /usr/bin/tex) is available.
		[[ -f doc/global.pdf ]] && DOCS+=( doc/global.pdf )
	fi

	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
