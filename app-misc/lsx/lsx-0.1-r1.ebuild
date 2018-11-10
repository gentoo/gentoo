# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="list executables"
HOMEPAGE="https://web.archive.org/web/20160104002819/http://tools.suckless.org:80/lsx"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( README )

src_prepare() {
	default

	sed -i \
		-e "s/.*strip.*//" \
		Makefile || die "sed failed"

	sed -i \
		-e "s/CFLAGS = -Os/CFLAGS +=/" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		config.mk || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	# collision with net-dialup/lrzsz
	mv "${D}/usr/bin/${PN}" "${D}/usr/bin/${PN}-suckless" || die

	einstalldocs
}

pkg_postinst() {
	elog "Run ${PN} with ${PN}-suckless"
}
