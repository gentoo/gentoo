# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Btrfs and xfs deduplication utility"
HOMEPAGE="https://github.com/markfasheh/duperemove/"
# XXX: drop .new on bump after 0.14, added for respin
SRC_URI="
	https://github.com/markfasheh/duperemove/archive/v${PV/_/.}.tar.gz
		-> ${P/_/.}.gh.new.tar.gz
"
S=${WORKDIR}/${P/_/.}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	emake VERSION="${PV}" IS_RELEASE=1 CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
