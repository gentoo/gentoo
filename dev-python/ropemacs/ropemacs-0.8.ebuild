# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils readme.gentoo

DESCRIPTION="Rope in Emacs"
HOMEPAGE="https://github.com/python-rope/ropemacs
	https://pypi.python.org/pypi/ropemacs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-1+"		# GPL without version
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/rope[${PYTHON_USEDEP}]
	dev-python/ropemode[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_install() {
	local DOCS="${DOCS} README.rst docs/*.rst"
	distutils-r1_src_install

	DOC_CONTENTS="In order to enable ropemacs support in Emacs, install
		app-emacs/pymacs and add the following line to your ~/.emacs file:
		\\n\\t(pymacs-load \"ropemacs\" \"rope-\")"
	readme.gentoo_create_doc
}
