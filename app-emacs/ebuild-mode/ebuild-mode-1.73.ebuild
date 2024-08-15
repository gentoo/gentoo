# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="sys-apps/texinfo"

DOCS="ChangeLog keyword-generation.sh"
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo-1.72.el"

pkg_postinst() {
	elisp_pkg_postinst
	optfeature "ebuild commands support" sys-apps/portage
	optfeature "additional development tools" dev-util/pkgdev
	optfeature "ebuild QA utilities" dev-util/pkgcheck
	optfeature "decode ANSI colors in build.log" app-emacs/tty-format
	optfeature "XML syntax validation" app-emacs/nxml-gentoo-schemas
	optfeature "generating HTML from GLEPs" dev-python/docutils-glep
}
