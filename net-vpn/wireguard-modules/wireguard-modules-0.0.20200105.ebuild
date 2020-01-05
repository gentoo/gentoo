# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE="module"
inherit linux-mod bash-completion-r1

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."
HOMEPAGE="https://www.wireguard.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/wireguard-linux-compat"
	KEYWORDS=""
else
	SRC_URI="https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${PV}.tar.xz"
	S="${WORKDIR}/wireguard-linux-compat-${PV}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +module module-src"

DEPEND=""
RDEPEND="${DEPEND} !<virtual/wireguard-1"

MODULE_NAMES="wireguard(kernel/drivers/net:src)"
BUILD_TARGETS="module"
CONFIG_CHECK="NET INET NET_UDP_TUNNEL CRYPTO_ALGAPI"

pkg_setup() {
	if use module; then
		linux-mod_pkg_setup
		if kernel_is -ge 5 6 0; then
			eerror
			eerror "WireGuard has been merged upstream in Linux 5.6. Therefore,"
			eerror "you no longer need this compatibility ebuild. Instead, simply"
			eerror "enable CONFIG_WIREGUARD=y in your kernel configuration."
			eerror
			die "Use CONFIG_WIREGUARD=y for kernels >= 5.6, and do not use this package."
		elif kernel_is -lt 3 10 0; then
			die "This version of ${PN} requires Linux >= 3.10."
		fi
	fi
}

src_compile() {
	BUILD_PARAMS="KERNELDIR=${KV_OUT_DIR}"
	use debug && BUILD_PARAMS="CONFIG_WIREGUARD_DEBUG=y ${BUILD_PARAMS}"
	use module && linux-mod_src_compile
}

src_install() {
	use module && linux-mod_src_install
	use module-src && emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" -C src dkms-install
}

pkg_postinst() {
	if use module-src && ! use module; then
		einfo
		einfo "You have enabled the module-src USE flag without the module USE"
		einfo "flag. This means that sources are installed to"
		einfo "${ROOT}/usr/src/wireguard instead of having the"
		einfo "kernel module compiled. You will need to compile the module"
		einfo "yourself. Most likely, you don't want this USE flag, and should"
		einfo "rather use USE=module"
		einfo
	fi

	if use module; then
		linux-mod_pkg_postinst
		local old new
		if [[ $(uname -r) != "${KV_FULL}" ]]; then
			ewarn
			ewarn "You have just built WireGuard for kernel ${KV_FULL}, yet the currently running"
			ewarn "kernel is $(uname -r). If you intend to use this WireGuard module on the currently"
			ewarn "running machine, you will first need to reboot it into the kernel ${KV_FULL}, for"
			ewarn "which this module was built."
			ewarn
		elif [[ -f /sys/module/wireguard/version ]] && \
		     old="$(< /sys/module/wireguard/version)" && \
		     new="$(modinfo -F version "${ROOT}/lib/modules/${KV_FULL}/net/wireguard.ko" 2>/dev/null)" && \
		     [[ $old != "$new" ]]; then
			ewarn
			ewarn "You appear to have just upgraded WireGuard from version v$old to v$new."
			ewarn "However, the old version is still running on your system. In order to use the"
			ewarn "new version, you will need to remove the old module and load the new one. As"
			ewarn "root, you can accomplish this with the following commands:"
			ewarn
			ewarn "    # rmmod wireguard"
			ewarn "    # modprobe wireguard"
			ewarn
			ewarn "Do note that doing this will remove current WireGuard interfaces, so you may want"
			ewarn "to gracefully remove them yourself prior."
			ewarn
		fi
	fi
}
