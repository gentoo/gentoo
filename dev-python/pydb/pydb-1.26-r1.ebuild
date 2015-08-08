# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit elisp-common python

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
	echo "#!/bin/sh" > py-compile

	# Fix pydb symlinks.
	sed -e '/$(LN_S) "$(DESTDIR)$(pkgpythondir)\/$(python_debugger_script)" "$(DESTDIR)$(bindir)\/$(bin_SCRIPTS)"/s/$(DESTDIR)$(pkgpythondir)/$(pkgpythondir)/' -i Makefile.in

	python_src_prepare
}

src_configure() {
	configuration() {
		econf --with-lispdir="${SITELISP}/${PN}" \
			EMACS="$(use emacs && echo "${EMACS}" || echo no)" \
			--with-site-packages=$(python_get_sitedir) \
			--with-python=$(PYTHON -a)
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

pkg_postinst() {
	python_mod_optimize pydb
}

pkg_postrm() {
	python_mod_cleanup pydb
}
