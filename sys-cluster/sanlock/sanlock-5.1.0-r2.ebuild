# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info systemd

DESCRIPTION="shared storage lock manager"
HOMEPAGE="https://codeberg.org/sanlock/sanlock"
SRC_URI="https://codeberg.org/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2+ GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="selinux"

DEPEND="
	dev-libs/libaio
	sys-apps/util-linux
	sys-fs/lvm2
"
RDEPEND="
	acct-user/${PN}
	acct-group/${PN}
	selinux? (
		sec-policy/selinux-sanlock
		sec-policy/selinux-wdmd
	)
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/sanlock-3.8.4-implicit-func-decls.patch"
)

CONFIG_CHECK="~SOFT_WATCHDOG"

src_compile() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/863734
	# https://pagure.io/sanlock/issue/10
	filter-lto

	for d in wdmd src; do
		emake -C ${d}
	done
}

src_install() {
	for d in wdmd src; do
		emake -C ${d} DESTDIR="${D}" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	done

	keepdir /var/lib/sanlock

	# config
	dodir /etc/wdmd.d
	dodir /etc/sanlock
	insinto /etc/sanlock
	doins src/sanlock.conf

	# init
	newconfd init.d/sanlock.sysconfig sanlock
	newconfd init.d/wdmd.sysconfig wdmd
	newinitd "${FILESDIR}"/sanlock.initd sanlock
	newinitd "${FILESDIR}"/wdmd.initd wdmd

	# systemd
	local utildir="$(systemd_get_utildir)"
	exeinto "${utildir#"${EPREFIX}"}"
	doexe init.d/systemd-wdmd
	systemd_dounit init.d/sanlock.service
	systemd_dounit init.d/wdmd.service
}
