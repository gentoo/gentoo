# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/philsquared/Catch"
SRC_URI="https://github.com/philsquared/Catch/archive/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S=${WORKDIR}/${P^}
CMAKE_USE_DIR=${S}/projects/CMake

src_configure() {
	# CMake is only used to build & run tests
	use test && cmake-utils_src_configure
}

src_compile() {
	use test && cmake-utils_src_compile
}

src_test() {
	use test && cmake-utils_src_test
}

src_install() {
	# same location as used in fedora
	insinto /usr/include/catch
	doins -r include/.
	dodoc -r docs/.
}
