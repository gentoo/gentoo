# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/philsquared/Catch"
SRC_URI="https://github.com/philsquared/Catch/archive/v${PV}.tar.gz -> ${P^}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${P^}

# CMake is only used to build & run tests, so override phases
src_configure() { :; }
src_compile() { :; }

src_test() {
	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_test
}

src_install() {
	# same location as used in fedora
	insinto /usr/include/catch
	doins -r include/.
	dodoc -r docs/.
}
