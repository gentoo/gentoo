# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A command line tool for compiling Arduino sketches"
HOMEPAGE="https://github.com/arduino/arduino-builder"
SRC_URI="https://github.com/arduino/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-devel/crossdev
	dev-embedded/avrdude
	dev-embedded/arduino-ctags"

src_compile() {
	GOBIN="${S}"/bin go install . || die
}

src_install() {
	dobin bin/arduino-builder
	# In addition to the binary, we also want to install these two files below. They are needed by
	# the dev-embedded/arduino which copies those files in its "hardware" folder.
	insinto "/usr/share/${PN}"
	doins hardware/platform.keys.rewrite.txt
	doins "${FILESDIR}/platform.txt"
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
