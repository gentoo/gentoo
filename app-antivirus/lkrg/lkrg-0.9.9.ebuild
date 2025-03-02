# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 systemd verify-sig

DESCRIPTION="Linux Kernel Runtime Guard"
HOMEPAGE="https://lkrg.org"
SRC_URI="https://lkrg.org/download/${P}.tar.gz
	verify-sig? ( https://lkrg.org/download/${P}.tar.gz.sign )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-openwall )"

# MODULE_NAMES="lkrg(misc:${S}:${S})"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/openwall.asc"

PATCHES=( "${FILESDIR}/${PN}-0.9.4-gentoo-paths.patch" )

pkg_setup() {
	CONFIG_CHECK="HAVE_KRETPROBES KALLSYMS_ALL KPROBES JUMP_LABEL"
	CONFIG_CHECK+=" MODULE_UNLOAD !PREEMPT_RT ~STACKTRACE"
	linux-mod-r1_pkg_setup
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.sign}
	fi

	default
}

src_compile() {
	local modlist=( lkrg )
	local modargs=(
		P_KVER="${KV_FULL}"
		P_KERNEL="${KERNEL_DIR}"
	)
	linux-mod-r1_src_compile

	emake LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" -C logger
}

src_install() {
	# logger target not included by all
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" -C logger install

	linux-mod-r1_src_install

	systemd_dounit scripts/bootup/systemd/lkrg.service
	newinitd scripts/bootup/openrc/lkrg lkrg.initd

	insinto /lib/sysctl.d
	newins scripts/bootup/lkrg.conf 01-lkrg.conf
}
