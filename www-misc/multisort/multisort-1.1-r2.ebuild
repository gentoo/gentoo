# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Merges httpd logfiles in the Common Log Format"
HOMEPAGE="https://www.xach.com/multisort/"
SRC_URI="https://www.xach.com/${PN}/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# respect LDFLAGS wrt bug #337359
	sed -i -e 's/$(CFLAGS)/& \$(LDFLAGS)/' Makefile || die 'sed on Makefile failed'
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin multisort
}
