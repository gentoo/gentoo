# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs pam

DESCRIPTION="Create per-user private temporary directories during login"
HOMEPAGE="https://www.openwall.com/pam/"
SRC_URI="https://www.openwall.com/pam/modules/${PN}/${P}.tar.gz"

LICENSE="BSD-2" # LICENSE file says "heavily cut-down 'BSD license'"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="selinux +prevent-removal"

RDEPEND="sys-libs/pam
	selinux? ( sys-libs/libselinux )"

DEPEND="${RDEPEND}
	prevent-removal? ( sys-kernel/linux-headers )"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-e2fsprogs-libs.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -fPIC" \
		LDFLAGS="${LDFLAGS} --shared -Wl,--version-script,\$(MAP)" \
		USE_SELINUX="$(use selinux && echo 1 || echo 0)" \
		USE_APPEND_FL="$(use prevent-removal && echo 1 || echo 0)"
}

src_install() {
	dopammod pam_mktemp.so
	dodoc README
}
