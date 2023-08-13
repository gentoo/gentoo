# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PF=${P/_p1/}
MY_P=${MY_PF}.pl01

DESCRIPTION="Open-source library for reading, mastering and writing optical discs"
HOMEPAGE="https://dev.lovelyhq.com/libburnia/web/wiki/Libisofs"
SRC_URI="http://files.libburnia-project.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="acl debug static-libs verbose-debug xattr zlib"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	acl? ( virtual/acl )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
"

S="${WORKDIR}/${MY_PF}"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable debug) \
	$(use_enable verbose-debug) \
	$(use_enable acl libacl) \
	$(use_enable xattr) \
	$(use_enable zlib) \
	--disable-libjte \
	--disable-ldconfig-at-install
}

src_install() {
	default

	dodoc Roadmap doc/{*.txt,Tutorial}

	find "${D}" -name '*.la' -delete || die
}
