# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/ebuild-mode.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
	S="${WORKDIR}/${PN}"
else
	SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="app-emacs/tty-format"
BDEPEND="${RDEPEND}
	sys-apps/texinfo"

DOCS="ChangeLog"
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo-1.81.el"

pkg_postinst() {
	elisp_pkg_postinst
	optfeature "ebuild commands support" sys-apps/portage
	optfeature "additional development tools" dev-util/pkgdev
	optfeature "ebuild QA utilities" dev-util/pkgcheck
	optfeature "XML syntax validation" app-emacs/nxml-gentoo-schemas
	optfeature "generating HTML from GLEPs" dev-python/docutils-glep
}
