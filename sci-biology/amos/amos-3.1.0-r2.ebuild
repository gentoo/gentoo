# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic python-r1

DESCRIPTION="A Modular, Open-Source whole genome assembler"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-3.1.0-fix-c++14.patch.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

DEPEND="qt4? ( dev-qt/qtcore:4 )"
RDEPEND="${DEPEND}
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-goBambus2.py-indent-and-cleanup.patch
	"${WORKDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-qa-Wformat.patch
)

src_configure() {
	# prevent GCC 6 log pollution due to hash_map deprecation in C++11
	append-cxxflags -Wno-cpp

	default
}

src_compile() {
	emake -j1
}

src_install() {
	default
	python_replicate_script "${ED%/}/usr/bin/goBambus2"
}
