# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=097f5be6e0c228790a6e78ffee5f0c599cb58b20
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Transient commands abstraction for GNU Emacs"
HOMEPAGE="https://magit.vc/manual/transient
	https://github.com/magit/transient"
SRC_URI="https://github.com/magit/transient/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DOCS=( README.org docs/transient.org )
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="docs/*.texi"

RDEPEND="app-emacs/compat"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

src_prepare() {
	mv lisp/*.el . || die

	default
}
