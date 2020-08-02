# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
SRC_URI="https://github.com/adrianlopezroche/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

src_prepare() {
	default
	append-lfs-flags
	sed -e "s#^CFLAGS= \(.*\)#CFLAGS= \1 ${CFLAGS}#g;" \
		-i "Makefile" || die "can't patch Makefile"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
