# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic libtool toolchain-funcs

DESCRIPTION="A spell checker replacement for ispell"
HOMEPAGE="http://aspell.net/"
SRC_URI="mirror://gnu/aspell/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

PDEPEND="app-dicts/aspell-en"
LANGS="af be bg br ca cs cy da de de@1901 el en eo es et fi fo fr ga gl he hr
is it la lt nl no pl pt pt-BR ro ru sk sl sr sv uk vi"
for lang in ${LANGS}; do
	IUSE+=" l10n_${lang/@/-}"
	# Need to keep linguas_* for now, since aspell uses gettext
	IUSE+=" linguas_${lang/-/_}"
	case ${lang} in
		de@1901) dict="de-alt"  ;;
		pt-BR)   dict="pt-br"   ;;
		*)       dict="${lang}" ;;
	esac
	PDEPEND+=" l10n_${lang/@/-}? ( app-dicts/aspell-${dict} )"
done
unset dict lang LANGS

COMMON_DEPEND="
	>=sys-libs/ncurses-5.2:0=
	nls? ( virtual/libintl )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

# English dictionary 0.5 is incompatible with aspell-0.6
RDEPEND="${COMMON_DEPEND}
	!=app-dicts/aspell-en-0.5*"

src_prepare() {
	# fix for bug #467602
	if has_version ">=sys-devel/automake-1.13" ; then
		sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
			"${S}"/configure.ac || die
	fi

	epatch \
		"${FILESDIR}/${PN}-0.60.5-nls.patch" \
		"${FILESDIR}/${PN}-0.60.5-solaris.patch" \
		"${FILESDIR}/${PN}-0.60.6-darwin-bundles.patch"

	rm m4/lt* m4/libtool.m4
	eautoreconf
	elibtoolize --reverse-deps

	# Parallel install of libtool libraries doesn't always work.
	# https://lists.gnu.org/archive/html/libtool/2011-03/msg00003.html
	# This has to be after automake has run so that we don't clobber
	# the default target that automake creates for us.
	echo 'install-filterLTLIBRARIES: install-libLTLIBRARIES' >> Makefile.in || die

}

src_configure() {
	if has_version "sys-libs/ncurses[unicode]" ; then
		CURSES_LIB="$($(tc-getPKG_CONFIG) --libs ncursesw)"
	else
		CURSES_LIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
	fi

	CURSES_LIB="${CURSES_LIB}" econf \
		$(use_enable nls) \
		--disable-static \
		--sysconfdir="${EPREFIX}"/etc/aspell \
		--enable-docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default

	dodoc README* TODO
	dohtml -r manual/aspell{,-dev}.html
	docinto examples
	dodoc "${S}"/examples/*.c

	# install ispell/aspell compatibility scripts
	newbin scripts/ispell ispell-aspell
	newbin scripts/spell spell-aspell

	prune_libtool_files
}

pkg_postinst() {
	elog "In case L10N was not set correctly you may need to install"
	elog "dictionaries now. Please choose an aspell-<LANG> dictionary or"
	elog "set L10N correctly and let aspell pull in required packages."
	elog "After installing an aspell dictionary for your language(s),"
	elog "You may use the aspell-import utility to import your personal"
	elog "dictionaries from ispell, pspell and the older aspell"
}
