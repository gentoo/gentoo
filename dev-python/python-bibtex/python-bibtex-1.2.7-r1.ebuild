# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="A Python extension to parse BibTeX files"
HOMEPAGE="https://pybliographer.org/"
SRC_URI="mirror://sourceforge/pybliographer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=app-text/recode-3.6-r1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

python_prepare_all() {
	# Disable tests during installation.
	sed -e "/self.run_command ('check')/d" -i setup.py

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py check
}
