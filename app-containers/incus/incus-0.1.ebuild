# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module linux-info optfeature systemd verify-sig

DESCRIPTION="Modern, secure and powerful system container and virtual machine manager"
HOMEPAGE="https://linuxcontainers.org/incus/introduction/ https://github.com/lxc/incus"
SRC_URI="https://linuxcontainers.org/downloads/incus/${P}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/incus/${P}.tar.gz.asc )"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

# incus conflicts with lxd due to fuidshift binary. Even if you replace the package, containers will remain.
DEPEND="acct-group/incus
	app-arch/xz-utils
	>=app-containers/lxc-5.0.0:=[seccomp(+)]
	dev-db/sqlite:3
	dev-libs/cowsql
	dev-libs/lzo
	>=dev-libs/raft-0.17.1:=[lz4]
	>=dev-util/xdelta-3.0[lzma(+)]
	net-dns/dnsmasq[dhcp]
	sys-libs/libcap
	virtual/udev"
RDEPEND="${DEPEND}
	!app-containers/lxd
	net-firewall/ebtables
	net-firewall/iptables
	sys-apps/iproute2
	sys-fs/fuse:*
	>=sys-fs/lxcfs-5.0.0
	sys-fs/squashfs-tools[lzma]
	virtual/acl"
BDEPEND="dev-lang/go
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
	/usr/bin/lxd-to-incus
	/usr/bin/incus-agent
	/usr/bin/incus-benchmark
	/usr/bin/incus-migrate
	/usr/sbin/incusd"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/linuxcontainers.asc

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

	# Disable -Werror's from go modules.
	find "${S}" -name "cgo.go" -exec sed -i "s/ -Werror / /g" {} + || die
}

src_configure() { :; }

src_compile() {
	export GOPATH="${S}/_dist"
	export CGO_LDFLAGS_ALLOW="-Wl,-z,now"

	# lxd-to-incus: this go module is packaged separately (0.1).
	for k in fuidshift incus-benchmark incus-user incus lxc-to-incus ; do
		go install -v -x "${S}/cmd/${k}" || die "failed compiling ${k}"
	done

	go install -v -x -tags libsqlite3 "${S}"/cmd/incusd || die "Failed to build the daemon"

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

	dosbin ${bindir}/incusd

	for l in fuidshift incus-agent incus-benchmark incus-migrate incus-user incus lxc-to-incus ; do
		dobin ${bindir}/${l}
	done

	dobashcomp scripts/bash/incus

	newconfd "${FILESDIR}"/incus-0.1.confd incus
	newinitd "${FILESDIR}"/incus-0.1.initd incus

	systemd_newunit "${FILESDIR}"/incus-0.1.service incus.service
	systemd_newunit "${FILESDIR}"/incus-containers-0.1.service incus-containers.service
	systemd_newunit "${FILESDIR}"/incus-0.1.socket incus.socket

	dodoc AUTHORS
	dodoc -r doc/*
	use nls && domo po/*.mo
}

pkg_postinst() {
	elog
	elog "Please see"
	elog "  https://linuxcontainers.org/incus/introduction/"
	elog "  https://linuxcontainers.org/incus/docs/main/tutorial/first_steps/"
	elog "before a Gentoo Wiki page is made."
	elog
	optfeature "virtual machine support" app-emulation/qemu[spice,usbredir,virtfs]
	optfeature "btrfs storage backend" sys-fs/btrfs-progs
	optfeature "ipv6 support" net-dns/dnsmasq[ipv6]
	optfeature "lvm2 storage backend" sys-fs/lvm2
	optfeature "zfs storage backend" sys-fs/zfs
	elog
	elog "Be sure to add your local user to the incus group."
	elog
}
