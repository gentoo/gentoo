# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python binding for MeCab"
HOMEPAGE="http://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN%-*}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc64 x86"
IUSE=""

DEPEND="~app-text/mecab-${PV}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-py3.diff" )
DOCS=( test.py )
HTML_DOCS=( bindings.html )
