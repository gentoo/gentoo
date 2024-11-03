# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"

RDEPEND=">=app-editors/xemacs-21.5.35
	app-xemacs/sh-script"
BDEPEND="${RDEPEND}"

EMACS="${EPREFIX}/usr/bin/xemacs"
EMACSFLAGS="-batch -q -no-site-file"

src_compile() {
	${EMACS} ${EMACSFLAGS} \
		-eval "(add-to-list 'load-path nil)" \
		-f batch-byte-compile \
		ebuild-mode.el gentoo-newsitem-mode.el || die

	${EMACS} ${EMACSFLAGS} \
		-eval "(setq autoload-package-name \"${PN}\")" \
		-eval "(setq generated-autoload-file \"${S}/auto-autoloads.el\")" \
		-l autoload -f batch-update-autoloads \
		ebuild-mode.el gentoo-newsitem-mode.el || die
}

src_test() {
	emake check EMACS="${EMACS}" EMACSFLAGS="${EMACSFLAGS}"
}

src_install() {
	insinto /usr/lib/xemacs/site-packages/lisp/${PN}
	doins ebuild-mode.{el,elc} ebuild-mode-keywords.el \
		gentoo-newsitem-mode.{el,elc}
	doins auto-autoloads.el
}

pkg_postinst() {
	optfeature "ebuild commands support" sys-apps/portage
	optfeature "additional development tools" dev-util/pkgdev
	optfeature "ebuild QA utilities" dev-util/pkgcheck
}
