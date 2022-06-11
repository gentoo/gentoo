# Copyright 1999-2022 Gentoo Authors
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.1-no-werror.patch
)

src_prepare() {
	sed -i \
		-e '/^all:/s:$: docs:' \
		-e '/^CFLAGS/s:-O2:@CFLAGS@:' \
		-e '/@CFLAGS@/ s:@CFLAGS@:@CFLAGS@ @LDFLAGS@:' \
		Makefile.in || die "sed failed"

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}
