# Copyright 1999-2020 Gentoo Authors
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

# A few tests fail after enforcing CFLAGS/LDFLAGS.
# We need to work out why.
RESTRICT="test"

src_prepare() {
	default

	cd ports/unix || die

	# 1) don't die on compiler warning
	# 2) remove /usr/local prefix references in favour of /usr
	# 3) enforce our CFLAGS
	# 4) enforce our LDFLAGS
	sed -e 's#-Werror##g;' \
		-e 's#\/usr\/local#\/usr#g;' \
		-e "s#^CFLAGS = \(.*\)#CFLAGS = \1 ${CFLAGS}#g" \
		-e "s#^LDFLAGS = \(.*\)#LDFLAGS = \1 ${LDFLAGS}#g" \
		-i Makefile || die "can't patch Makefile"
}

src_compile() {
	cd ports/unix || die

	emake CC="$(tc-getCC)" axtls
	emake CC="$(tc-getCC)"
}

src_test() {
	cd ports/unix || die
	emake CC="$(tc-getCC)" test
}

src_install() {
	pushd ports/unix > /dev/null || die
	emake CC="$(tc-getCC)" DESTDIR="${D}" install
	popd > /dev/null || die

	# remove .git files
	find tools -type f -name '.git*' -exec rm {} \; || die

	dodoc -r tools
	einstalldocs
}
