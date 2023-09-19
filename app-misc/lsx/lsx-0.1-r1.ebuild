# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="list executables"
HOMEPAGE="https://web.archive.org/web/20160104002819/http://tools.suckless.org:80/lsx"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default

	# overengineered build system
	rm Makefile config.mk || die
}

src_configure() {
	tc-export CC
	append-cppflags -DVERSION='\"0.1\"'
}

src_compile() {
	emake lsx
}

src_install() {
	# collision with net-dialup/lrzsz
	newbin ${PN} ${PN}-suckless

	einstalldocs
}

pkg_postinst() {
	elog "Run ${PN} with ${PN}-suckless"
}
