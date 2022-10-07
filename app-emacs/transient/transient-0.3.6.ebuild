# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=25

inherit elisp

DESCRIPTION="Transient commands abstraction for GNU Emacs"
HOMEPAGE="https://magit.vc/manual/transient"
SRC_URI="https://github.com/magit/transient/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="docs/*.texi"
DOCS="README.md docs/transient.org"

DEPEND=""
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} sys-apps/texinfo"

src_prepare() {
	mv lisp/*.el . || die

	default
}
