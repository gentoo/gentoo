# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info optfeature systemd verify-sig

DESCRIPTION="Modern, secure and powerful system container and virtual machine manager"
HOMEPAGE="https://linuxcontainers.org/incus/introduction/ https://github.com/lxc/incus"
SRC_URI="https://linuxcontainers.org/downloads/incus/${P}.tar.xz
	verify-sig? ( https://linuxcontainers.org/downloads/incus/${P}.tar.xz.asc )"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="apparmor fuidshift nls"

DEPEND="acct-group/incus
	acct-group/incus-admin
	app-arch/xz-utils
	>=app-containers/lxc-5.0.0:=[apparmor?,seccomp(+)]
	dev-db/sqlite:3
	dev-libs/cowsql
	dev-libs/lzo
	>=dev-libs/raft-0.22.0:=[lz4]
	>=dev-util/xdelta-3.0[lzma(+)]
	net-dns/dnsmasq[dhcp]
	sys-libs/libcap
	virtual/udev"
RDEPEND="${DEPEND}
	fuidshift? ( !app-containers/lxd )
	net-firewall/ebtables
	net-firewall/iptables
	sys-apps/iproute2
	sys-fs/fuse:*
	>=sys-fs/lxcfs-5.0.0
	sys-fs/squashfs-tools[lzma]
	virtual/acl"
BDEPEND=">=dev-lang/go-1.21
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

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
QA_PREBUILT="/usr/bin/incus
	/usr/bin/lxc-to-incus
	/usr/bin/incus-agent
	/usr/bin/incus-benchmark
	/usr/bin/incus-migrate
	/usr/sbin/fuidshift
	/usr/sbin/lxd-to-incus
	/usr/sbin/incusd"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/linuxcontainers.asc

# The testsuite must be run as root.
# make: *** [Makefile:156: check] Error 1
RESTRICT="test"

GOPATH="${S}/_dist"

src_prepare() {
	export GOPATH="${S}/_dist"

	default

	sed -i \
		-e "s:\./configure:./configure --prefix=/usr --libdir=${EPREFIX}/usr/lib/incus:g" \
		-e "s:make:make ${MAKEOPTS}:g" \
		Makefile || die

	# Fix hardcoded ovmf file path, see bug 763180
	sed -i \
		-e "s:/usr/share/OVMF:/usr/share/edk2-ovmf:g" \
		-e "s:OVMF_VARS.ms.fd:OVMF_VARS.fd:g" \
		doc/environment.md \
		internal/server/apparmor/instance.go \
		internal/server/apparmor/instance_qemu.go \
		internal/server/instance/drivers/driver_qemu.go || die "Failed to fix hardcoded ovmf paths."

	# Fix hardcoded virtfs-proxy-helper file path, see bug 798924
	sed -i \
		-e "s:/usr/lib/qemu/virtfs-proxy-helper:/usr/libexec/virtfs-proxy-helper:g" \
		internal/server/device/device_utils_disk.go || die "Failed to fix virtfs-proxy-helper path."

	cp "${FILESDIR}"/incus-0.4.service "${T}"/incus.service || die
	if use apparmor; then
		sed -i \
			'/^EnvironmentFile=.*/a ExecStartPre=\/usr\/libexec\/lxc\/lxc-apparmor-load' \
			"${T}"/incus.service || die
	fi

	# Disable -Werror's from go modules.
	find "${S}" -name "cgo.go" -exec sed -i "s/ -Werror / /g" {} + || die
}

src_configure() { :; }

src_compile() {
	export GOPATH="${S}/_dist"
	export CGO_LDFLAGS_ALLOW="-Wl,-z,now"

	for k in incus-benchmark incus-simplestreams incus-user incus lxc-to-incus lxd-to-incus ; do
		ego install -v -x "${S}/cmd/${k}"
	done

	if use fuidshift ; then
		ego install -v -x "${S}/cmd/fuidshift"
	fi

	ego install -v -x -tags libsqlite3 "${S}"/cmd/incusd

	# Needs to be built statically
	CGO_ENABLED=0 go install -v -tags netgo "${S}"/cmd/incus-migrate
	CGO_ENABLED=0 go install -v -tags agent,netgo "${S}"/cmd/incus-agent

	use nls && emake build-mo
}

src_test() {
	emake check
}

src_install() {
	export GOPATH="${S}/_dist"
	local bindir="_dist/bin"

	newsbin "${FILESDIR}"/incus-startup-0.4.sh incus-startup

	# Admin tools
	for l in incusd incus-user lxd-to-incus ; do
		dosbin ${bindir}/${l}
	done

	# User tools
	for m in incus-agent incus-benchmark incus-migrate incus-simplestreams incus lxc-to-incus ; do
		dobin ${bindir}/${m}
	done

	# fuidshift, should be moved under admin tools at some point
	if use fuidshift ; then
		dosbin ${bindir}/fuidshift
	fi

	newconfd "${FILESDIR}"/incus-0.4.confd incus
	newinitd "${FILESDIR}"/incus-0.4.initd incus
	newinitd "${FILESDIR}"/incus-user-0.4.initd incus-user

	systemd_dounit "${T}"/incus.service
	systemd_newunit "${FILESDIR}"/incus-0.4.socket incus.socket
	systemd_newunit "${FILESDIR}"/incus-startup-0.4.service incus-startup.service
	systemd_newunit "${FILESDIR}"/incus-user-0.4.service incus-user.service
	systemd_newunit "${FILESDIR}"/incus-user-0.4.socket incus-user.socket

	# Generate and install shell completion files.
	mkdir -p "${D}"/usr/share/{bash-completion/completions/,fish/vendor_completions.d/,zsh/site-functions/} || die
	"${bindir}"/incus completion bash > "${D}"/usr/share/bash-completion/completions/incus || die
	"${bindir}"/incus completion fish > "${D}"/usr/share/fish/vendor_completions.d/incus.fish || die
	"${bindir}"/incus completion zsh > "${D}"/usr/share/zsh/site-functions/_incus || die

	dodoc AUTHORS
	dodoc -r doc/*
	use nls && domo po/*.mo
}

pkg_postinst() {
	elog
	elog "Please see"
	elog "  https://wiki.gentoo.org/wiki/Incus"
	elog "  https://wiki.gentoo.org/wiki/Incus#Migrating_from_LXD"
	elog
	optfeature "virtual machine support" app-cdr/cdrtools app-emulation/qemu[spice,usbredir,virtfs]
	optfeature "btrfs storage backend" sys-fs/btrfs-progs
	optfeature "ipv6 support" net-dns/dnsmasq[ipv6]
	optfeature "full incus-migrate support" net-misc/rsync
	optfeature "lvm2 storage backend" sys-fs/lvm2
	optfeature "zfs storage backend" sys-fs/zfs
	elog
	elog "Be sure to add your local user to the incus group."
	elog
}
