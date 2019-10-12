# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit toolchain-funcs pam eutils

DESCRIPTION="Create per-user private temporary directories during login"
HOMEPAGE="http://www.openwall.com/pam/"
SRC_URI="http://www.openwall.com/pam/modules/${PN}/${P}.tar.gz"

LICENSE="BSD-2" # LICENSE file says "heavily cut-down 'BSD license'"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="selinux +prevent-removal"

RDEPEND="sys-libs/pam
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	prevent-removal? ( sys-kernel/linux-headers )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-e2fsprogs-libs.patch
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

pkg_postinst() {
	elog "To enable pam_mktemp put something like"
	elog
	elog "session    optional    pam_mktemp.so"
	elog
	elog "into /etc/pam.d/system-auth!"
}
