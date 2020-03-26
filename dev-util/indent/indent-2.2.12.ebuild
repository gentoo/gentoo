# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Indent program source files"
HOMEPAGE="https://www.gnu.org/software/indent/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
	app-text/texi2html
"
RDEPEND="
	nls? ( virtual/libintl )
"

src_prepare() {
	default

	sed -i -e '/AM_CFLAGS/s:-Werror::g' src/Makefile.{am,in} || die
}

src_configure() {
	strip-linguas -i po/

	if use nls; then
		gl_cv_cc_vis_werror=no \
		econf $(use_enable nls)
	else
		ac_cv_func_setlocale=no \
		gl_cv_cc_vis_werror=no \
		econf $(use_enable nls)
	fi
}

src_test() {
	emake -C regression/
}

src_install() {
	# htmldir as set in configure is ignored in doc/Makefile*
	emake DESTDIR="${D}" htmldir="${EPREFIX}/usr/share/doc/${PF}/html" install
	dodoc AUTHORS NEWS README.md ChangeLog ChangeLog-1990 ChangeLog-1998 ChangeLog-2001
}
