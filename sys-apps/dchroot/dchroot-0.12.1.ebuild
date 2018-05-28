# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Utility for managing chroots for non-root users"
HOMEPAGE="https://packages.debian.org/unstable/admin/dchroot"
SRC_URI="mirror://debian/pool/main/d/dchroot/dchroot_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/help2man"
RDEPEND="!dev-util/schroot[dchroot]"

src_prepare() {
	default
	sed -i \
		-e '/^all:/s:$: docs:' \
		-e '/^CFLAGS/s:-O2:@CFLAGS@:' \
		-e '/@CFLAGS@/ s:@CFLAGS@:@CFLAGS@ @LDFLAGS@:' \
		Makefile.in || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}
