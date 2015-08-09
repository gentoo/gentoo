# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Digramic Bayesian text classifier"
HOMEPAGE="http://www.lbreyer.com/gpl.html"
SRC_URI="http://www.lbreyer.com/gpl/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 s390 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="interactive"

RDEPEND="interactive? (
		sys-libs/slang:=
		sys-libs/readline:=
		sys-libs/ncurses:= )"

DEPEND="${RDEPEND}"

src_prepare() {
	# See bug #352636 for reference
	export ac_cv_lib_ncurses_initscr=$(usex interactive)
	export ac_cv_lib_readline_readline=$(usex interactive)
	export ac_cv_lib_slang_SLsmg_init_smg=$(usex interactive)
}
