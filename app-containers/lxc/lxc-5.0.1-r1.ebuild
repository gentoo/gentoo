# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 linux-info meson optfeature systemd toolchain-funcs verify-sig

DESCRIPTION="A userspace interface for the Linux kernel containment features"
HOMEPAGE="https://linuxcontainers.org/ https://github.com/lxc/lxc"
SRC_URI="https://linuxcontainers.org/downloads/lxc/${P}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/lxc/${P}.tar.gz.asc )"

LICENSE="GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apparmor +caps examples io-uring lto man pam seccomp selinux ssl systemd test +tools"

RDEPEND="acct-group/lxc
	acct-user/lxc
	apparmor? ( sys-libs/libapparmor )
	caps? ( sys-libs/libcap[static-libs] )
	io-uring? ( >=sys-libs/liburing-2:= )
	pam? ( sys-libs/pam )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sys-libs/libselinux )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tools? ( sys-libs/libcap[static-libs] )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="virtual/pkgconfig
	man? ( app-text/docbook2X )
	verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

RESTRICT="!test? ( test )"

CONFIG_CHECK="~!NETPRIO_CGROUP
	~CGROUPS
	~CGROUP_CPUACCT
	~CGROUP_DEVICE
	~CGROUP_FREEZER

	~CGROUP_SCHED
	~CPUSETS
	~IPC_NS
	~MACVLAN

	~MEMCG
	~NAMESPACES
	~NET_NS
	~PID_NS

	~POSIX_MQUEUE
	~USER_NS
	~UTS_NS
	~VETH"

ERROR_CGROUP_FREEZER="CONFIG_CGROUP_FREEZER: needed to freeze containers"
ERROR_MACVLAN="CONFIG_MACVLAN: needed for internal (inter-container) networking"
ERROR_MEMCG="CONFIG_MEMCG: needed for memory resource control in containers"
ERROR_NET_NS="CONFIG_NET_NS: needed for unshared network"
ERROR_POSIX_MQUEUE="CONFIG_POSIX_MQUEUE: needed for lxc-execute command"
ERROR_UTS_NS="CONFIG_UTS_NS: needed to unshare hostnames and uname info"
ERROR_VETH="CONFIG_VETH: needed for internal (host-to-container) networking"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/linuxcontainers.asc

DOCS=( AUTHORS CONTRIBUTING MAINTAINERS README.md doc/FAQ.txt )

PATCHES=( "${FILESDIR}"/lxc-5.0.1-glibc-2.36.patch
	"${FILESDIR}"/lxc-5.0.1-use-sd_bus_call_method_async-insteaf-of-asyncv.patch )

pkg_setup() {
	linux-info_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dcoverity-build=false
		-Doss-fuzz=false

		-Dcommands=true
		-Dmemfd-rexec=true
		-Dthread-safety=true

		$(meson_use apparmor)
		$(meson_use caps capabilities)
		$(meson_use examples)
		$(meson_use io-uring io-uring-event-loop)
		$(meson_use lto b_lto)
		$(meson_use man)
		$(meson_use pam pam-cgroup)
		$(meson_use seccomp)
		$(meson_use selinux)
		$(meson_use ssl openssl)
		$(meson_use test tests)
		$(meson_use tools)

		-Ddata-path=/var/lib/lxc
		-Ddoc-path=/usr/share/doc/${PF}
		-Dlog-path=/var/log/lxc
		-Drootfs-mount-path=/var/lib/lxc/rootfs
		-Druntime-path=/run
	)

	if use systemd; then
		local emesonargs+=( -Dinit-script="systemd" )
		local emesonargs+=( -Dsd-bus=enabled )
	else
		local emesonargs+=( -Dinit-script="sysvinit" )
		local emesonargs+=( -Dsd-bus=disabled )
	fi

	use tools && local emesonargs+=( -Dcapabilities=true )

	if $(tc-ld-is-gold) || $(tc-ld-is-lld); then
		local emesonargs+=( -Db_lto_mode=thin )
	else
		local emesonargs+=( -Db_lto_mode=default )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	# The main bash-completion file will collide with lxd, need to relocate and update symlinks.
	mkdir -p "${ED}"/$(get_bashcompdir) || die "Failed to create bashcompdir."

	if use tools; then
		bashcomp_alias lxc-start lxc-{attach,autostart,cgroup,checkpoint,config,console,copy,create,destroy,device,execute,freeze,info,ls,monitor,snapshot,stop,top,unfreeze,unshare,usernsexec,wait}
	else
		bashcomp_alias lxc-start lxc-usernsexec
	fi

	keepdir /var/lib/cache/lxc /var/lib/lib/lxc

	find "${ED}" -name '*.la' -delete -o -name '*.a' -delete || die

	# Replace upstream sysvinit/systemd files.
	if use systemd; then
		rm -r "${D}$(systemd_get_systemunitdir)" || die "Failed to remove systemd lib dir"
	else
		rm "${ED}"/etc/init.d/lxc-{containers,net} || die "Failed to remove sysvinit scripts"
	fi

	newinitd "${FILESDIR}/${PN}.initd.8" ${PN}
	systemd_newunit "${FILESDIR}"/lxc-monitord.service.5.0.0 lxc-monitord.service
	systemd_newunit "${FILESDIR}"/lxc-net.service.5.0.0 lxc-net.service
	systemd_newunit "${FILESDIR}"/lxc.service-5.0.0 lxc.service
	systemd_newunit "${FILESDIR}"/lxc_at.service.5.0.0 "lxc@.service"

	if ! use apparmor; then
		sed -i '/lxc-apparmor-load/d' "${D}$(systemd_get_systemunitdir)/lxc.service" || die "Failed to remove apparmor references from lxc.service systemd unit."
	fi
}

pkg_postinst() {
	elog "Please refer to "
	elog "https://wiki.gentoo.org/wiki/LXC for introduction and usage guide."
	elog
	elog "Run 'lxc-checkconfig' to see optional kernel features."
	elog

	optfeature "automatic template scripts" app-containers/lxc-templates
	optfeature "Debian-based distribution container image support" dev-util/debootstrap
	optfeature "snapshot & restore functionality" sys-process/criu
}
