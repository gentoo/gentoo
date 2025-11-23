# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig toolchain-funcs

DESCRIPTION="lightweight session manager with {de,at}tach support"
HOMEPAGE="https://www.brain-dump.org/projects/abduco/"
SRC_URI="https://www.brain-dump.org/projects/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

src_prepare() {
	default

	sed -e 's:^PREFIX.*:PREFIX = /usr:' \
		-e 's/-Os//' \
		-e '/^CC/d' \
		-i config.mk || die

	sed -e "s/VERSION/${PV}/g" \
		-i ${PN}.1 || die

	sed -e '/@echo CC/d' \
		-e 's|@${CC}|$(CC)|g' \
		-i Makefile || die

	restore_config config.def.h

	tc-export CC
}

src_test() {
	./testsuite.sh || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
	doman ${PN}.1

	save_config config.def.h
}
