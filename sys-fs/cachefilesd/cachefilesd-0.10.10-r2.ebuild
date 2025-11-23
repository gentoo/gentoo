# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd toolchain-funcs tmpfiles readme.gentoo-r1

DESCRIPTION="Provides a caching directory on an already mounted filesystem"
HOMEPAGE="https://people.redhat.com/~dhowells/fscache/"
SRC_URI="https://people.redhat.com/~dhowells/fscache/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~riscv x86"
IUSE="doc selinux"

RDEPEND="selinux? ( sec-policy/selinux-cachefilesd )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.9-makefile.patch
)

src_prepare() {
	default
	if ! use selinux; then
		sed -e '/^secctx/s:^:#:g' -i cachefilesd.conf || die
	fi

	tc-export CC
	append-flags -fpie

	# bug #908661
	use elibc_musl && append-flags -D_LARGEFILE64_SOURCE
}

src_install() {
	default

	readme.gentoo_create_doc

	if use selinux; then
		dodoc -r selinux
		docompress -x /usr/share/doc/${PF}/selinux
	fi

	dodoc howto.txt

	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	newinitd "${FILESDIR}"/${PN}-3.init ${PN}

	sed -i 's@ExecStart=/usr@ExecStart=@' ${PN}.service || die "failed to fix path"
	systemd_dounit ${PN}.service
	newtmpfiles "${FILESDIR}"/${PN}-tmpfiles.d ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	if [[ ! -d /var/cache/fscache ]]; then
		FORCE_PRINT_ELOG=1
	fi
	readme.gentoo_print_elog
}
