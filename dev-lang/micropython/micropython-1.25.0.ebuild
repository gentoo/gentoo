# Copyright 1999-2025 Gentoo Creators & Daniella Kicsak
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Python implementation for microcontrollers"
HOMEPAGE="https://micropython.org https://github.com/micropython/micropython"
SRC_URI="https://micropython.org/resources/source/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libffi:=
	virtual/pkgconfig
"

src_prepare() {
	default
	cd "${S}/ports/unix" || die

	# 1) don't die on compiler warning
	# 2) remove /usr/local prefix references in favour of /usr
	# 3) enforce our CFLAGS (Only change the first `CFLAGS +=`)
	# 4) enforce our LDFLAGS (Only change the first `LDFLAGS +=`)
	sed -e 's#-Werror##g;' \
		-e 's#\/usr\/local#\/usr#g;' \
		-e "0,/^CFLAGS +=/{s#^CFLAGS += \(.*\)#CFLAGS += \1 ${CFLAGS}#g}" \
		-e "0,/^LDFLAGS +=/{s#^LDFLAGS += \(.*\)#LDFLAGS += \1 ${LDFLAGS}#g}" \
		-i Makefile || die "can't patch Makefile"

	cd "${S}/mpy-cross" || die

	# `mpy-cross` needs the same. There's no `/usr/local` paths however.
	sed -e 's#-Werror##g;' \
		-e "0,/^CFLAGS +=/{s#^CFLAGS += \(.*\)#CFLAGS += \1 ${CFLAGS}#g}" \
		-e "0,/^LDFLAGS +=/{s#^LDFLAGS += \(.*\)#LDFLAGS += \1 ${LDFLAGS}#g}" \
		-i Makefile || die "can't patch Makefile"
}

src_compile() {
	# Build the cross-compiler first. Build fails without this.
	einfo ""
	einfo "Building the mpy-crosscompiler."
	einfo ""
	cd "${S}/mpy-cross" || die
	emake CC="$(tc-getCC)"

	# Finally, build the unix port.
	einfo ""
	einfo "Building the micropython unix port."
	einfo ""
	cd "${S}/ports/unix" || die
	# Empty `STRIP=` leaves symbols + debug info intact. Let portage handle it.
	# https://github.com/micropython/micropython/tree/master/ports/unix/README.md
	emake CC="$(tc-getCC)" STRIP=
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
