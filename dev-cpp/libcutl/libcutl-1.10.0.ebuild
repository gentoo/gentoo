# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

DESCRIPTION="A collection of C++ libraries (successor of libcult)"
HOMEPAGE="http://www.codesynthesis.com/projects/libcutl/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/expat
	dev-libs/boost:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.10.0-fix-c++14.patch" )

src_prepare() {
	default

	# remove bundled libs
	rm -r cutl/details/{boost,expat} || die
}

src_configure() {
	econf \
		--disable-static \
		--with-external-boost \
		--with-external-expat
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
