# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 toolchain-funcs

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="http://leenissen.dk/fann/wp/"
EGIT_REPO_URI="https://github.com/libfann/fann"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples"

src_test() {
	cd examples || die 'fails to enter examples directory'
	LD_LIBRARY_PATH="${BUILD_DIR}/src" GCC="$(tc-getCC) ${CFLAGS} -I../src/include -L${BUILD_DIR}/src" emake -e runtest
	emake clean
}

src_install() {
	cmake_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
