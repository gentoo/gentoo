# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/eselect.git"

inherit autotools git-r3 bash-completion-r1

DESCRIPTION="Gentoo's multi-purpose configuration and management tool"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Eselect"

LICENSE="GPL-2+ || ( GPL-2+ CC-BY-SA-3.0 )"
SLOT="0"
IUSE="doc emacs vim-syntax"

RDEPEND="sys-apps/sed
	|| (
		sys-apps/coreutils
		app-misc/realpath
	)"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"
RDEPEND="${RDEPEND}
	sys-apps/file
	sys-libs/ncurses:0"

PDEPEND="emacs? ( app-emacs/eselect-mode )
	vim-syntax? ( app-vim/eselect-syntax )"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	emake DESTDIR="${D}" install
	newbashcomp misc/${PN}.bashcomp ${PN}
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
	if use doc; then
		docinto html
		dodoc *.html doc/*.html doc/*.css
	fi

	# needed by news module
	keepdir /var/lib/gentoo/news
	if ! use prefix; then
		fowners root:portage /var/lib/gentoo/news
		fperms g+w /var/lib/gentoo/news
	fi
}

pkg_postinst() {
	# fowners in src_install doesn't work for the portage group:
	# merging changes the group back to root
	if ! use prefix; then
		chgrp portage "${EROOT}/var/lib/gentoo/news" \
			&& chmod g+w "${EROOT}/var/lib/gentoo/news"
	fi
}
