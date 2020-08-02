# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Module for manipulating ID3 tags in Python"
HOMEPAGE="http://pyid3lib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="media-libs/id3lib"
RDEPEND="${DEPEND}"

HTML_DOCS=( doc.html )

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${P}-gcc-4.4.patch"
		"${FILESDIR}/${P}-py25.patch"
	)

	distutils-r1_src_prepare

	append-flags -fno-strict-aliasing
}
