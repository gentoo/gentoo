# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Recipe Organizer and Shopping List Generator for Gnome"
HOMEPAGE="https://thinkle.github.com/gourmet/"
SRC_URI="https://github.com/thinkle/gourmet/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-i18n -ipython pdf print spell sound web"

RDEPEND=">=dev-python/pygtk-2.22.0:2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.9-r1[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	i18n? ( dev-python/elib-intl[${PYTHON_USEDEP}] )
	ipython? ( >=dev-python/ipython-0.13.2[${PYTHON_USEDEP}] )
	pdf? (
		>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
		>=dev-python/python-poppler-0.12.1-r4[${PYTHON_USEDEP}]
	)
	print? (
		>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
		>=dev-python/python-poppler-0.12.1-r4[${PYTHON_USEDEP}]
	)
	spell? ( >=dev-python/gtkspell-python-2.25.3-r1[${PYTHON_USEDEP}] )
	sound? ( >=dev-python/gst-python-0.10.22-r1:0.10[${PYTHON_USEDEP}] )
	web? ( >=dev-python/beautifulsoup-3.2.1-r1:python-2[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-util/intltool
	>=dev-python/python-distutils-extra-2.37-r1[${PYTHON_USEDEP}]"

PATCHES=( ${FILESDIR}/no-docs-0.17.0.patch )
DOCS=( ChangeLog CODING.md FAQ README.md TESTS TODO.md )

python_prepare_all() {
	# Modify these lines before copying them out
	sed -i "s:base_dir = '..':base_dir = '/usr/share':" gourmet/settings.py || die
	sed -i 's:data_dir = os.path.join(base_dir, "gourmet", "data"):data_dir = os.path.join(base_dir, "gourmet"):' gourmet/settings.py || die
	sed -i 's:\(icon_base = os.path.join(data_dir,\) "icons",:\1 "gourmet",:' gourmet/settings.py || die
	sed -i 's:\(locale_base = os.path.join(base_dir, "gourmet",\) "build",:\1:' gourmet/settings.py || die
	sed -i 's:\(plugin_base = os.path.join(base_dir,\) "gourmet", "build", "share",:\1:' gourmet/settings.py || die
	distutils-r1_python_prepare_all
}

python_prepare() {
	distutils-r1_python_prepare
	sed -i "s:\(lib_dir = \)'../gourmet':\1'$(python_get_sitedir)':" gourmet/settings.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	doman gourmet.1
}
