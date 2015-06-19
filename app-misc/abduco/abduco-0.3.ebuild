# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/abduco/abduco-0.3.ebuild,v 1.1 2015/02/20 00:24:17 xmw Exp $

EAPI=5

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="lightweight session manager with {de,at}tach support"
HOMEPAGE="http://www.brain-dump.org/projects/abduco/"
SRC_URI="http://www.brain-dump.org/projects/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
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
	epatch_user

	tc-export CC
}

src_test() {
	./testsuite.sh || die
}

src_install() {
	dobin ${PN}
	dodoc README
	doman ${PN}.1

	save_config config.def.h
}
