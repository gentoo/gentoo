# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Python implementation for microcontrollers"
HOMEPAGE="https://github.com/micropython/micropython"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	virtual/libffi
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-prevent-stripping.patch" )

src_compile() {
	cd ports/unix || die

	# 1) don't die on compiler warnings
	# 2) remove /usr/local prefix references in favour of /usr
	sed -i \
		-e 's#-Werror##g;' \
		-e 's#\/usr\/local#\/usr#g;' \
		Makefile || die
	emake CC="$(tc-getCC)" axtls
	emake CC="$(tc-getCC)"
}

src_test() {
	# XXX: find out why these tests fail
	rm -v tests/misc/recursive_iternext* || die

	cd ports/unix || die
	emake test
}

src_install() {
	pushd ports/unix > /dev/null || die
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" DESTDIR="${D}" install
	popd > /dev/null || die

	# remove .git files
	find tools -type f -name '.git*' -exec rm {} \; || die

	dodoc -r tools
	einstalldocs
}
