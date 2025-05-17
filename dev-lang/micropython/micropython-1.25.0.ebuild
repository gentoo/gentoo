# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Python implementation for microcontrollers"
HOMEPAGE="https://micropython.org https://github.com/micropython/micropython"
SRC_URI="https://micropython.org/resources/source/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libffi:=
	virtual/pkgconfig
"

src_prepare() {
	default

	for i in ports/unix mpy-cross; do
		# 1) don't die on compiler warning
		# 2) enforce our CFLAGS (Only change the first `CFLAGS +=`)
		# 3) enforce our LDFLAGS (Only change the first `LDFLAGS +=`)
		sed -e 's#-Werror##g;' \
			-e "0,/^CFLAGS +=/{s#^CFLAGS += \(.*\)#CFLAGS += \1 ${CFLAGS}#g}" \
			-e "0,/^LDFLAGS +=/{s#^LDFLAGS += \(.*\)#LDFLAGS += \1 ${LDFLAGS}#g}" \
			-i $i/Makefile || die "can't patch Makefile"

		if [ $i == 'ports/unix' ]; then
			# 4) remove /usr/local prefix references in favour of /usr
			sed -e 's#\/usr\/local#\/usr#g;' -i $i/Makefile
		fi
	done
}

src_compile() {
	# Build the cross-compiler first. Build fails without this.
	einfo ""
	einfo "Building the mpy-crosscompiler."
	einfo ""
	emake -C mpy-cross CC="$(tc-getCC)"

	# Finally, build the unix port.
	einfo ""
	einfo "Building the micropython unix port."
	einfo ""
	# Empty `STRIP=` leaves symbols + debug info intact. Let portage handle it.
	# https://github.com/micropython/micropython/tree/master/ports/unix/README.md
	emake -C ports/unix CC="$(tc-getCC)" STRIP=
}

src_test() {
	emake -C ports/unix CC="$(tc-getCC)" test
}

src_install() {
	emake -C ports/unix CC="$(tc-getCC)" DESTDIR="${D}" install

	# remove .git files
	find tools -type f -name '.git*' -delete || die

	dodoc -r tools
	einstalldocs
}
