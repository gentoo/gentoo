# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic autotools prefix

CONFVER="1.10"

DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
HOMEPAGE="https://www.tcsh.org/"
SRC_URI="
	https://astron.com/pub/tcsh/${P}.tar.gz
	https://astron.com/pub/tcsh/old/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/tcsh-gentoo-patches-r${CONFVER}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="nls man"
RESTRICT="test"

# we need gettext because we run autoconf (AM_ICONV)
RDEPEND="
	>=sys-libs/ncurses-5.1:0=
	virtual/libcrypt:=
	virtual/libiconv"
DEPEND="${RDEPEND}
	sys-devel/gettext"

CONFDIR=${WORKDIR}/tcsh-gentoo-patches-r${CONFVER}

PATCHES=(
	"${FILESDIR}"/${PN}-6.21.00-use-ncurses.patch
)

src_prepare() {
	default

	eautoreconf

	# fix gencat usage
	sed \
		-e 's/cat \$\^ \$> | \$(GENCAT) \$@/rm -f $@; $(GENCAT) $@ $> $^/' \
		-i nls/Makefile.in || die

	# always use sysmalloc, the builtin malloc fails on Darwin, musl,
	# etc. it's already used for glibc-linux, so this doesn't change
	# anything for the majority of users
	sed -i -e 's/undef SYSMALLOC/define SYSMALLOC/' config_f.h || die

	# unify ECHO behaviour
	echo "#undef ECHO_STYLE" >> config_f.h
	echo "#define ECHO_STYLE      BOTH_ECHO" >> config_f.h

	eprefixify "${CONFDIR}"/*
	# activate the right default PATH
	if [[ -z ${EPREFIX} ]] ; then
		sed -i \
			-e 's/^#MAIN//' -e '/^#PREFIX/d' \
			"${CONFDIR}"/csh.login || die
	else
		sed -i \
			-e 's/^#PREFIX//' -e '/^#MAIN/d' \
			"${CONFDIR}"/csh.login || die
	fi
}

src_configure() {
	# make tcsh look and live along the lines of the prefix
	append-cppflags -D_PATH_DOTCSHRC="'"'"${EPREFIX}/etc/csh.cshrc"'"'"
	append-cppflags -D_PATH_DOTLOGIN="'"'"${EPREFIX}/etc/csh.login"'"'"
	append-cppflags -D_PATH_DOTLOGOUT="'"'"${EPREFIX}/etc/csh.logout"'"'"
	append-cppflags -D_PATH_USRBIN="'"'"${EPREFIX}/usr/bin"'"'"
	append-cppflags -D_PATH_BIN="'"'"${EPREFIX}/bin"'"'"

	# musl's utmp is non-functional
	if use elibc_musl ; then
		export ac_cv_header_utmp_h=no
		export ac_cv_header_utmpx_h=no
	fi

	econf \
		--prefix="${EPREFIX:-}" \
		--datarootdir='${prefix}/usr/share' \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install install.man

	DOCS=( FAQ Fixes Ported README.md WishList Y2K )
	einstalldocs

	if ! use man ; then
		rm -Rf "${ED}"/usr/share/man
	fi

	insinto /etc
	doins \
		"${CONFDIR}"/csh.cshrc \
		"${CONFDIR}"/csh.login

	# bug #119703: add csh -> tcsh symlink
	dosym tcsh /bin/csh
}
