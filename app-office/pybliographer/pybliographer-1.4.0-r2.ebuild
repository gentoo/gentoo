# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="Pybliographer is a tool for working with bibliographic databases"
HOMEPAGE="https://pybliographer.org"

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
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.24.0:2[${PYTHON_USEDEP}]
	>=dev-python/python-bibtex-1.2.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
"

# Tests broken for a long time, they rely on non-standard PATH for python
# modules, bug #678444
RESTRICT="test"

src_prepare() {
	# Workaround for bug 487204.
	sed -i \
		-e 's:\$(srcdir)/::g' \
		tests/Makefile.am || die "sed failed"

	# Install Python modules into site-packages directories.
	find -name Makefile.am | xargs sed -i \
		-e "/^pybdir[[:space:]]*=[[:space:]]*/s:\$(datadir):$(python_get_sitedir):" || die "sed failed"
	sed -i -e 's:prefix=:cd @datapyb@ \&\& prefix=:' scripts/pybscript.in || die
	sed -i -e "s:\@datapyb@:$(python_get_sitedir)/${PN}:g" pybliographer.in scripts/pybscript.in || die
	sed -i \
		-e "s:gladedir = \$(datadir):gladedir = $(python_get_sitedir):" \
		Pyblio/GnomeUI/glade/Makefile.am || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-depchecks
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"
	dodir /usr/share/${PN}
	mv "${D}/$(python_get_sitedir)/${PN}/pixmaps" "${ED}"/usr/share/${PN} || die
}
