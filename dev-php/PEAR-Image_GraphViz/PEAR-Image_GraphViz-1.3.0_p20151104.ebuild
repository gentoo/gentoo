# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 vcs-snapshot

DESCRIPTION="PHP interface to AT&T's GraphViz tools"
SRC_URI="https://github.com/pear/Image_GraphViz/archive/3f8a01ae0597ca9d1d08a6e442cb0b153358fc0d.tar.gz -> ${PEAR_P}.tar.gz"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="media-gfx/graphviz"
DEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"
PATCHES=( "${FILESDIR}/Image_GraphViz-1.3.0-constructor.patch" )
S="${WORKDIR}/${PEAR_P}"

src_prepare() {
	mv "${S}/package.xml" "${WORKDIR}" || die
	default
}

src_test() {
	peardev run-tests tests || die
}
