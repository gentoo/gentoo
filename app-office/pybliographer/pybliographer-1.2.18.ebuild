# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="Pybliographer is a tool for working with bibliographic databases"
HOMEPAGE="https://pybliographer.org"
SRC_URI="mirror://sourceforge/pybliographer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-text/recode-3.6-r1
	app-text/rarian
	dev-libs/glib:2
	dev-python/gconf-python:2[${PYTHON_USEDEP}]
	dev-python/gnome-vfs-python:2[${PYTHON_USEDEP}]
	dev-python/libgnome-python:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=dev-python/python-bibtex-1.2.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
"

# Tests broken for a long time, recheck in 1.4, bug #678444
RESTRICT="test"

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

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-depchecks \
		--disable-update-desktop-database
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"
}
