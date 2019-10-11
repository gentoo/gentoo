# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="https://www.gnu.org/software/bc/bc.html"
SRC_URI="mirror://gnu-alpha/bc/${P}.tar.bz2
	mirror://gnu/bc/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit readline static"

RDEPEND="
	!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		>=sys-libs/readline-4.1:0=
		>=sys-libs/ncurses-5.2:=
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
	virtual/yacc
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-void_uninitialized.patch #349339
	epatch "${FILESDIR}"/${P}-mem-leak.patch #264889
}

src_configure() {
	export CONFIG_SHELL=${BASH}

	local libedit
	if use readline ; then
		libedit="--without-libedit"
	else
		libedit=$(use_with libedit)
	fi
	use static && append-ldflags -static
	# Clobber any CONFIG_SHELL setting the user has forced on us.
	# We should be able to delete this w/the next release as it
	# should use updated autoconf.
	CONFIG_SHELL=/bin/bash \
	econf \
		$(use_with readline) \
		${libedit}

	# Do not regen docs -- configure produces a small fragment that includes
	# the version info which causes all pages to regen (newer file). #554774
	touch -r doc doc/*
}

src_compile() {
	emake AR="$(tc-getAR)"
}
