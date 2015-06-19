# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mongo-c-driver/mongo-c-driver-0.7.1-r1.ebuild,v 1.4 2014/08/13 09:28:50 ago Exp $

EAPI=5
PYTHON_COMPAT=(python2_7)

inherit multilib python-r1 toolchain-funcs

DESCRIPTION="C Driver for MongoDB"
HOMEPAGE="http://www.mongodb.org/ https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/${PN}/tarball/v${PV/_/} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE="doc static-libs"

# tests fails to build
RESTRICT="test"

RDEPEND=""
DEPEND="doc? ( dev-python/sphinx )"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	# bug #510722
	sed -e 's/-O3//g' \
		-e 's/-ggdb//g' \
		-e "s/CC:=.*/CC:=$(tc-getCC)/g" \
		-i Makefile || die
}

src_compile() {
	emake
	use doc && make -C docs/source/sphinx html
}

src_install() {
	emake install \
		INSTALL_LIBRARY_PATH="${D}/usr/$(get_libdir)" \
		INSTALL_INCLUDE_PATH="${D}/usr/include"

	use static-libs || find "${ED}" -name '*.a' -exec rm -f {} +

	use doc && dohtml -r docs/source/sphinx/build/html/*
}
