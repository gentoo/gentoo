# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND=">=app-editors/xemacs-21.4.20-r5
	app-xemacs/sh-script"
BDEPEND="${RDEPEND}"

src_compile() {
	local XEMACS="${EPREFIX}/usr/bin/xemacs"

	"${XEMACS}" -batch -q --no-site-file \
		-eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile \
		ebuild-mode.el gentoo-newsitem-mode.el || die

	"${XEMACS}" -batch -q --no-site-file \
		-eval "(setq autoload-package-name \"${PN}\")" \
		-eval "(setq generated-autoload-file \"${S}/auto-autoloads.el\")" \
		-l autoload -f batch-update-autoloads \
		ebuild-mode.el gentoo-newsitem-mode.el || die
}

src_install() {
	insinto /usr/share/xemacs/site-packages/lisp/${PN}
	doins *.el *.elc
}
