# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/pybliographer/pybliographer-1.2.15-r1.ebuild,v 1.5 2015/04/18 13:17:41 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
GCONF_DEBUG="no"

inherit autotools gnome2 python-single-r1

DESCRIPTION="Pybliographer is a tool for working with bibliographic databases"
HOMEPAGE="http://pybliographer.org/"
SRC_URI="mirror://sourceforge/pybliographer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-text/recode-3.6-r1
	app-text/scrollkeeper
	dev-libs/glib:2
	dev-python/gconf-python:2[${PYTHON_USEDEP}]
	dev-python/gnome-vfs-python:2[${PYTHON_USEDEP}]
	dev-python/libgnome-python:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=dev-python/python-bibtex-1.2.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
"

src_prepare() {
	# Workaround for bug 487204.
	sed -i \
		-e 's:\$(srcdir)/::g' \
		tests/Makefile.am || die "sed failed"

	# Install Python modules into site-packages directories.
	find -name Makefile.am | xargs sed -i \
		-e "/^pybdir[[:space:]]*=[[:space:]]*/s:\$(datadir):$(python_get_sitedir):" || die "sed failed"
	sed -i \
		-e "s:\${datadir}/@PACKAGE@:$(python_get_sitedir)/@PACKAGE@:" \
		etc/installer.in || die "sed failed"
	sed -i \
		-e "s:gladedir = \$(datadir):gladedir = $(python_get_sitedir):" \
		Pyblio/GnomeUI/glade/Makefile.am || die "sed failed"

	# Fix shebang manually as otherwise python_fix_shebang gets confused
	sed -i -e 's: @python_path@:/usr/bin/python2:' pybliographer.py || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-depchecks
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"
}
