# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MODULES_OPTIONAL_USE="module"
inherit linux-mod bash-completion-r1

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."
HOMEPAGE="https://www.wireguard.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/WireGuard"
	KEYWORDS=""
else
	SRC_URI="https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${PV}.tar.xz"
	S="${WORKDIR}/WireGuard-${PV}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +module +tools module-src"

DEPEND="tools? ( net-libs/libmnl )"
RDEPEND="${DEPEND}"

MODULE_NAMES="wireguard(kernel/drivers/net:src)"
BUILD_TARGETS="module"
CONFIG_CHECK="NET INET NET_UDP_TUNNEL CRYPTO_BLKCIPHER"

pkg_setup() {
	if use module; then
		linux-mod_pkg_setup
		kernel_is -lt 3 10 0 && die "This version of ${PN} requires Linux >= 3.10"
	fi
}

src_compile() {
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	use debug && BUILD_PARAMS="CONFIG_WIREGUARD_DEBUG=y ${BUILD_PARAMS}"
	use module && linux-mod_src_compile
	use tools && emake RUNSTATEDIR="${EPREFIX}/run" -C src/tools
}

src_install() {
	use module && linux-mod_src_install
	if use tools; then
		dodoc README.md
		dodoc -r contrib/examples
		emake \
			WITH_BASHCOMPLETION=yes \
			WITH_SYSTEMDUNITS=yes \
			WITH_WGQUICK=yes \
			DESTDIR="${D}" \
			BASHCOMPDIR="$(get_bashcompdir)" \
			PREFIX="${EPREFIX}/usr" \
			-C src/tools install
		insinto /$(get_libdir)/netifrc/net
		newins "${FILESDIR}"/wireguard-openrc.sh wireguard.sh
	fi
	use module-src && emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" -C src dkms-install
}

pkg_postinst() {
	if use module-src && ! use module; then
		einfo
		einfo "You have enabled the module-src USE flag without the module USE"
		einfo "flag. This means that sources are installed to"
		einfo "${ROOT}usr/src/wireguard instead of having the"
		einfo "kernel module compiled. You will need to compile the module"
		einfo "yourself. Most likely, you don't want this USE flag, and should"
		einfo "rather use USE=module"
		einfo
	fi
	use module && linux-mod_pkg_postinst

	einfo
	einfo "This software is experimental and has not yet been released."
	einfo "As such, it may contain significant issues. Please do not file"
	einfo "bug reports with Gentoo, but rather direct them upstream to:"
	einfo
	einfo "    team@wireguard.com    security@wireguard.com"
	einfo

	if use tools; then
		einfo
		einfo "After installing WireGuard, if you'd like to try sending some packets through"
		einfo "WireGuard, you may use, for testing purposes only, the insecure client.sh"
		einfo "test example script:"
		einfo
		einfo "  \$ bzcat ${ROOT}usr/share/doc/${PF}/examples/ncat-client-server/client.sh.bz2 | sudo bash -"
		einfo
		einfo "This will automatically setup interface wg0, through a very insecure transport"
		einfo "that is only suitable for demonstration purposes. You can then try loading the"
		einfo "hidden website or sending pings:"
		einfo
		einfo "  \$ chromium http://192.168.4.1"
		einfo "  \$ ping 192.168.4.1"
		einfo
		einfo "If you'd like to redirect your internet traffic, you can run it with the"
		einfo "\"default-route\" argument. You may not use this server for any abusive or illegal"
		einfo "purposes. It is for quick testing only."
		einfo
		einfo "More info on getting started can be found at: https://www.wireguard.com/quickstart/"
		einfo
	fi
	if use module; then
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
