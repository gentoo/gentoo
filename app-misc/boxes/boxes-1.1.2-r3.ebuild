# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Draw any kind of boxes around your text"
HOMEPAGE="https://boxes.thomasjensen.com/ https://github.com/ascii-boxes/boxes"
SRC_URI="https://github.com/ascii-boxes/boxes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	sys-devel/flex
	sys-devel/bison"

src_prepare() {
	default
	append-cflags -Iregexp -I. -ansi -std=c99
	append-ldflags -Lregexp
	sed \
		-e 's:STRIP=true:STRIP=false:g' \
		-i src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/boxes
	doman doc/boxes.1
	insinto /usr/share
	newins boxes-config boxes
	einstalldocs
}
