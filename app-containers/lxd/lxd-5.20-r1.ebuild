# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module linux-info optfeature systemd verify-sig

DESCRIPTION="Modern, secure and powerful system container and virtual machine manager"
HOMEPAGE="https://ubuntu.com/lxd https://github.com/canonical/lxd"
SRC_URI="https://github.com/canonical/lxd/releases/download/${P}/${P}.tar.gz
	verify-sig? ( https://github.com/canonical/lxd/releases/download/${P}/${P}.tar.gz.asc
)"

LICENSE="Apache-2.0 AGPL-3+ BSD LGPL-3 MIT"
SLOT="0/stable"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="apparmor nls"

DEPEND="acct-group/lxd
	app-arch/xz-utils
	>=app-containers/lxc-5.0.0:=[apparmor?,seccomp(+)]
	dev-db/sqlite:3
	>=dev-libs/dqlite-1.16.4:=[lz4]
	dev-libs/lzo
	>=dev-util/xdelta-3.0[lzma(+)]
	net-dns/dnsmasq[dhcp]
	sys-libs/libcap
	virtual/udev"
RDEPEND="${DEPEND}
	|| (
			net-firewall/nftables[json]
			(
				net-firewall/ebtables
				net-firewall/iptables
			)
	)
	sys-apps/iproute2
	sys-fs/fuse:3
	>=sys-fs/lxcfs-5.0.0
	sys-fs/squashfs-tools[lzma]
	virtual/acl"
BDEPEND=">=dev-lang/go-1.20
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-canonical )"

CONFIG_CHECK="
	~CGROUPS
	~IPC_NS
	~NET_NS
	~PID_NS

	~SECCOMP
	~USER_NS
	~UTS_NS

	~KVM
	~MACVTAP
	~VHOST_VSOCK
"

ERROR_IPC_NS="CONFIG_IPC_NS is required."
ERROR_NET_NS="CONFIG_NET_NS is required."
ERROR_PID_NS="CONFIG_PID_NS is required."
ERROR_SECCOMP="CONFIG_SECCOMP is required."
ERROR_UTS_NS="CONFIG_UTS_NS is required."

WARNING_KVM="CONFIG_KVM and CONFIG_KVM_AMD/-INTEL is required for virtual machines."
WARNING_MACVTAP="CONFIG_MACVTAP is required for virtual machines."
WARNING_VHOST_VSOCK="CONFIG_VHOST_VSOCK is required for virtual machines."

# Go magic.
QA_PREBUILT="/usr/bin/fuidshift
	/usr/bin/lxc
	/usr/bin/lxc-to-lxd
	/usr/bin/lxd-agent
	/usr/bin/lxd-benchmark
	/usr/bin/lxd-migrate
	/usr/sbin/lxd"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/canonical.asc

# The testsuite must be run as root.
# make: *** [Makefile:156: check] Error 1
RESTRICT="test"

GOPATH="${S}/_dist"

src_prepare() {
	export GOPATH="${S}/_dist"

	default

	sed -i \
		-e "s:\./configure:./configure --prefix=/usr --libdir=${EPREFIX}/usr/lib/lxd:g" \
		-e "s:make:make ${MAKEOPTS}:g" \
		Makefile || die

	# Fix hardcoded ovmf file path, see bug 763180
	sed -i \
		-e "s:/usr/share/OVMF:/usr/share/edk2-ovmf:g" \
		-e "s:OVMF_VARS.ms.fd:OVMF_VARS.fd:g" \
		doc/environment.md \
		lxd/apparmor/instance.go \
		lxd/apparmor/instance_qemu.go \
		lxd/instance/drivers/driver_qemu.go || die "Failed to fix hardcoded ovmf paths."

	# Fix hardcoded virtfs-proxy-helper file path, see bug 798924
	sed -i \
		-e "s:/usr/lib/qemu/virtfs-proxy-helper:/usr/libexec/virtfs-proxy-helper:g" \
		lxd/device/device_utils_disk.go || die "Failed to fix virtfs-proxy-helper path."

	cp "${FILESDIR}"/lxd-4.0.9-r1.service "${T}"/lxd.service || die
	if use apparmor; then
		sed -i \
			'/^EnvironmentFile=.*/a ExecStartPre=\/usr\/libexec\/lxc\/lxc-apparmor-load' \
			"${T}"/lxd.service || die
	fi

	# Disable -Werror's from go modules.
	find "${S}" -name "cgo.go" -exec sed -i "s/ -Werror / /g" {} + || die
}

src_configure() { :; }

src_compile() {
	export GOPATH="${S}/_dist"
	export CGO_LDFLAGS_ALLOW="-Wl,-z,now"

	for k in fuidshift lxd-benchmark lxc lxc-to-lxd; do
		go install -v -x "${S}/${k}" || die "failed compiling ${k}"
	done

	go install -v -x -tags libsqlite3 "${S}"/lxd || die "Failed to build the daemon"

	# Needs to be built statically
	CGO_ENABLED=0 go install -v -tags netgo "${S}"/lxd-migrate
	CGO_ENABLED=0 go install -v -tags agent,netgo "${S}"/lxd-agent

	use nls && emake build-mo
}

src_test() {
	emake check
}

src_install() {
	export GOPATH="${S}/_dist"
	local bindir="_dist/bin"

	dosbin ${bindir}/lxd

	for l in fuidshift lxd-agent lxd-benchmark lxd-migrate lxc lxc-to-lxd; do
		dobin ${bindir}/${l}
	done

	newbashcomp scripts/bash/lxd-client lxc

	newconfd "${FILESDIR}"/lxd-4.0.0.confd lxd
	newinitd "${FILESDIR}"/lxd-5.0.2-r1.initd lxd

	systemd_dounit "${T}"/lxd.service
	systemd_newunit "${FILESDIR}"/lxd-containers-4.0.0.service lxd-containers.service
	systemd_newunit "${FILESDIR}"/lxd-4.0.0.socket lxd.socket

	dodoc AUTHORS
	dodoc -r doc/*
	use nls && domo po/*.mo
}

pkg_postinst() {
	elog
	elog "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	elog "including a Quick Start."
	elog "For virtual machine support, see:"
	elog "https://wiki.gentoo.org/wiki/LXD#Virtual_machines"
	elog
	elog "Please run 'lxc-checkconfig' to see all optional kernel features."
	elog
	optfeature "virtual machine support" app-emulation/qemu[spice,usbredir,virtfs]
	optfeature "btrfs storage backend" sys-fs/btrfs-progs
	optfeature "ipv6 support" net-dns/dnsmasq[ipv6]
	optfeature "full lxd-migrate support" net-misc/rsync
	optfeature "lvm2 storage backend" sys-fs/lvm2
	optfeature "zfs storage backend" sys-fs/zfs
	elog
	elog "Be sure to add your local user to the lxd group."
}
