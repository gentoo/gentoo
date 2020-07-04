# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_6 )

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

PATCHES=( "${FILESDIR}"/${PN}-python3.patch )
DOCS=( AUTHORS README test.py )
HTML_DOCS=( bindings.html )
