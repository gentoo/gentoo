# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Btrfs and xfs deduplication utility"
HOMEPAGE="https://github.com/markfasheh/duperemove/"
SRC_URI="
	https://github.com/markfasheh/duperemove/archive/v${PV/_/.}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${P/_/.}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	sys-apps/util-linux:=
"
DEPEND="
	${RDEPEND}
	dev-libs/libbsd
	dev-libs/xxhash
"

src_configure() {
	tc-export CC PKG_CONFIG
	export VERSION="${PV}"
	export IS_RELEASE=1
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
