# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

inherit toolchain-funcs python-any-r1

DESCRIPTION="Python implementation for microcontrollers"
HOMEPAGE="https://micropython.org https://github.com/micropython/micropython"
SRC_URI="https://micropython.org/resources/source/${P}.tar.xz"

LICENSE="Apache-2.0 BSD BSD-1 BSD-4 GPL-2 GPL-2+ ISC LGPL-3 MIT OFL-1.1 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libffi:=
	virtual/pkgconfig
	${PYTHON_DEPS}
"

src_prepare() {
	default

	# Both ports/unix and mpy-cross need their Makefile changed.
	# 1) don't die on compiler warning
	# 2) remove /usr/local prefix references in favour of /usr
	# 3) enforce our CFLAGS (Only change the first `CFLAGS +=`)
	# 4) enforce our LDFLAGS (Only change the first `LDFLAGS +=`)
	sed -e 's#-Werror##g;' \
		-e "s#/usr/local#${EPREFIX}#g" \
		-e "0,/^CFLAGS +=/{s#^CFLAGS += \(.*\)#CFLAGS += \1 ${CFLAGS}#g}" \
		-e "0,/^LDFLAGS +=/{s#^LDFLAGS += \(.*\)#LDFLAGS += \1 ${LDFLAGS}#g}" \
		-i ports/unix/Makefile mpy-cross/Makefile || die "can't patch Makefile"
}

src_compile() {
	# Build the cross-compiler first. Build fails without this.
	einfo ""
	einfo "Building the mpy-crosscompiler."
	einfo ""
	emake V=1 -C mpy-cross CC="$(tc-getCC)"

	# Finally, build the unix port.
	einfo ""
	einfo "Building the micropython unix port."
	einfo ""
	# Empty `STRIP=` leaves symbols + debug info intact. Let portage handle it.
	# https://github.com/micropython/micropython/tree/master/ports/unix/README.md
	emake V=1 -C ports/unix CC="$(tc-getCC)" STRIP=
}

src_test() {
	emake V=1 -C ports/unix CC="$(tc-getCC)" test
}

src_install() {
	emake V=1 -C ports/unix CC="$(tc-getCC)" DESTDIR="${D}" install

	# remove .git files
	find tools -type f -name '.git*' -delete || die

	dodoc -r tools
	einstalldocs
}
