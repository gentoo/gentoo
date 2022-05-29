# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24

inherit elisp

DESCRIPTION="Compatibility libraries for Emacs"
HOMEPAGE="https://git.sr.ht/~pkal/compat"
SRC_URI="https://git.sr.ht/~pkal/compat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-apps/texinfo"

ELISP_TEXINFO="compat.texi"

src_prepare() {
	default
	rm Makefile compat-tests.el || die
}
