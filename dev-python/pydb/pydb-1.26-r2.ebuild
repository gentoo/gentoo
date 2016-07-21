# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit elisp-common python-single-r1

DESCRIPTION="Extended python debugger"
HOMEPAGE="http://bashdb.sourceforge.net/pydb/"
SRC_URI="mirror://sourceforge/bashdb/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

DEPEND="
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix pydb symlinks.
	sed -e '/$(LN_S) "$(DESTDIR)$(pkgpythondir)\/$(python_debugger_script)" "$(DESTDIR)$(bindir)\/$(bin_SCRIPTS)"/s/$(DESTDIR)$(pkgpythondir)/$(pkgpythondir)/' -i Makefile.in
}

src_configure() {
	econf --with-lispdir="${SITELISP}/${PN}" \
		EMACS="$(usex emacs "${EMACS}" no)" \
		--with-python="${PYTHON}"
#			--with-site-packages=$(python_get_sitedir) \
}
