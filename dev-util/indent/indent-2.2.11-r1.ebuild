# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Indent program source files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
	app-text/texi2html
"
RDEPEND="
	nls? ( virtual/libintl )
"

src_prepare() {
	# Fix bug #94837
	local pofile
	for pofile in po/zh_TW*; do
		mv ${pofile} ${pofile/.Big5} || die
	done
	sed -i po/LINGUAS -e 's|zh_TW\.Big5|zh_TW|g' || die

	epatch \
		"${FILESDIR}"/${P}-segfault.patch \
		"${FILESDIR}"/${P}-texi2html-5.patch
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_test() {
	emake -C regression/
}

src_install() {
	# htmldir as set in configure is ignored in doc/Makefile*
	emake DESTDIR="${D}" htmldir="${EPREFIX}/usr/share/doc/${PF}/html" install
	dodoc AUTHORS NEWS README ChangeLog ChangeLog-1990 ChangeLog-1998 ChangeLog-2001
}
