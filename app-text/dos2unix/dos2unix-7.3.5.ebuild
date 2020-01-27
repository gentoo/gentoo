# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="da de eo es fr hu ja nb nl pl pt_BR ru sr sv uk vi zh_CN zh_TW"

inherit l10n toolchain-funcs

DESCRIPTION="Convert DOS or MAC text files to UNIX format or vice versa"
HOMEPAGE="http://www.xs4all.nl/~waterlan/dos2unix.html https://sourceforge.net/projects/dos2unix/"
SRC_URI="
	http://www.xs4all.nl/~waterlan/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="debug nls test"

RDEPEND="
	!app-text/hd2u
	virtual/libintl"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	test? ( virtual/perl-Test-Simple )
	dev-lang/perl"

RESTRICT="!test? ( test )"

handle_locales() {
	# Make sure locale list is kept up-to-date.
	local detected sorted
	detected=$(echo $(printf '%s\n' */*.po | sed -e 's:.*/::' -e 's:.po$::' | sort -u))
	sorted=$(echo $(printf '%s\n' ${PLOCALES} | sort -u))
	if [[ ${sorted} != "${detected}" ]] ; then
		eerror "The ebuild needs to be kept in sync."
		eerror "PLOCALES: ${sorted}"
		eerror "po*/*.po: ${detected}"
		die "sync PLOCALES"
	fi

	# Deal with selective install of locales.
	rm_loc() { rm po*/$1.po || die; }
	l10n_for_each_disabled_locale_do rm_loc
}

src_prepare() {
	default

	handle_locales

	sed \
		-e '/^LDFLAGS/s|=|+=|' \
		-e '/CFLAGS_OS \+=/d' \
		-e '/LDFLAGS_EXTRA \+=/d' \
		-e "/^CFLAGS/s|-O2|${CFLAGS}|" \
		-i Makefile || die

	if use debug ; then
		sed -e "/^DEBUG/s:0:1:" \
			-e "/EXTRA_CFLAGS +=/s:-g::" \
			-i Makefile || die
	fi

	tc-export CC
}

lintl() {
	# same logic as from virtual/libintl
	use !elibc_glibc && use !elibc_uclibc && use !elibc_musl && echo "-lintl"
}

src_compile() {
	emake prefix="${EPREFIX}/usr" \
		$(usex nls "LDFLAGS_EXTRA=$(lintl)" "ENABLE_NLS=")
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		$(usex nls "" "ENABLE_NLS=") install
}
