# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 linux-info optfeature systemd verify-sig

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/ https://github.com/lxc/lxd"
SRC_URI="https://linuxcontainers.org/downloads/lxd/${P}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/lxd/${P}.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="apparmor ipv6 nls verify-sig"

DEPEND="acct-group/lxd
	app-arch/xz-utils
	>=app-emulation/lxc-3.0.0[apparmor?,seccomp(+)]
	dev-db/sqlite:3
	dev-libs/dqlite
	dev-libs/lzo
	dev-libs/raft[lz4]
	>=dev-util/xdelta-3.0[lzma(+)]
	net-dns/dnsmasq[dhcp,ipv6?]
	sys-libs/libcap
	virtual/udev"
RDEPEND="${DEPEND}
	net-firewall/ebtables
	net-firewall/iptables[ipv6?]
	sys-apps/iproute2[ipv6?]
	sys-fs/fuse:*
	sys-fs/lxcfs
	sys-fs/squashfs-tools[lzma]
	virtual/acl"
BDEPEND="dev-lang/go
	nls? ( sys-devel/gettext )
	verify-sig? ( app-crypt/openpgp-keys-linuxcontainers )"

CONFIG_CHECK="
	~CGROUPS
	~IPC_NS
	~NET_NS
	~PID_NS

	~SECCOMP
	~USER_NS
	~UTS_NS
"

ERROR_IPC_NS="CONFIG_IPC_NS is required."
ERROR_NET_NS="CONFIG_NET_NS is required."
ERROR_PID_NS="CONFIG_PID_NS is required."
ERROR_SECCOMP="CONFIG_SECCOMP is required."
ERROR_UTS_NS="CONFIG_UTS_NS is required."

# Go magic.
QA_PREBUILT="/usr/bin/fuidshift
	/usr/bin/lxc
	/usr/bin/lxc-to-lxd
	/usr/bin/lxd-agent
	/usr/bin/lxd-benchmark
	/usr/bin/lxd-p2c
	/usr/sbin/lxd"

EGO_PN="github.com/lxc/lxd"
GOPATH="${S}/_dist" # this seems to reset every now and then, though

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/linuxcontainers.asc

# The testsuite must be run as root.
# make: *** [Makefile:156: check] Error 1
RESTRICT="test"

PATCHES=( "${FILESDIR}"/lxd-4.0.8-btrfs-progs-5.14-safety-check-fix.patch
	"${FILESDIR}"/lxd-4.0.7-no-werror.patch )

src_prepare() {
	default

	export GOPATH="${S}/_dist"

	sed -i \
		-e "s:\./configure:./configure --prefix=/usr --libdir=${EPREFIX}/usr/lib/lxd:g" \
		-e "s:make:make ${MAKEOPTS}:g" \
		Makefile || die

	# Fix hardcoded ovmf file path, see bug 763180
	sed -i \
		-e "s:/usr/share/OVMF:/usr/share/edk2-ovmf:g" \
		-e "s:OVMF_VARS.ms.fd:OVMF_VARS.secboot.fd:g" \
		doc/environment.md \
		lxd/apparmor/instance_qemu.go \
		lxd/instance/drivers/driver_qemu.go || die "Failed to fix hardcoded ovmf paths."

	# Fix hardcoded virtfs-proxy-helper file path, see bug 798924
	sed -i \
		-e "s:/usr/lib/qemu/virtfs-proxy-helper:/usr/libexec/virtfs-proxy-helper:g" \
		lxd/device/disk.go || die "Failed to fix virtfs-proxy-helper path."

	cp "${FILESDIR}"/lxd-4.0.7-r1.service "${T}"/lxd.service || die
	if use apparmor; then
		sed -i \
			'/^EnvironmentFile=.*/a ExecStartPre=\/usr\/libexec\/lxc\/lxc-apparmor-load' \
			"${T}"/lxd.service || die
	fi
}

src_configure() { :; }

src_compile() {
	export GOPATH="${S}/_dist"
	export GO111MODULE=auto
	export CGO_LDFLAGS_ALLOW="-Wl,-z,now"

	cd "${S}" || die

	for k in fuidshift lxd-benchmark lxc lxc-to-lxd; do
		go install -v -x "${EGO_PN}/${k}" || die "failed compiling ${k}"
	done

	go install -v -x -tags libsqlite3 ${EGO_PN}/lxd || die "Failed to build the daemon"

	# Needs to be built statically
	CGO_ENABLED=0 go install -v -tags netgo "${EGO_PN}"/lxd-p2c
	CGO_ENABLED=0 go install -v -tags agent,netgo "${EGO_PN}"/lxd-agent

	use nls && emake build-mo
}

src_test() {
	emake check
}

src_install() {
	local bindir="_dist/bin"
	export GOPATH="${S}/_dist"

	dosbin ${bindir}/lxd

	for l in fuidshift lxd-agent lxd-benchmark lxd-p2c lxc lxc-to-lxd; do
		dobin ${bindir}/${l}
	done

	cd "${S}" || die

	newbashcomp scripts/bash/lxd-client lxc

	newconfd "${FILESDIR}"/lxd-4.0.0.confd lxd
	newinitd "${FILESDIR}"/lxd-4.0.0.initd lxd

	systemd_dounit "${T}"/lxd.service

	systemd_newunit "${FILESDIR}"/lxd-containers-4.0.0.service lxd-containers.service
	systemd_newunit "${FILESDIR}"/lxd-4.0.0.socket lxd.socket

	# Temporary fix for #817287
	keepdir /var/log/lxd
	fowners root:lxd /var/log/lxd

	dodoc AUTHORS doc/*
	use nls && domo po/*.mo
}

pkg_postinst() {
	elog
	elog "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	elog "including a Quick Start."
	elog
	elog "Please run 'lxc-checkconfig' to see all optional kernel features."
	elog
	optfeature "btrfs storage backend" sys-fs/btrfs-progs
	optfeature "lvm2 storage backend" sys-fs/lvm2
	optfeature "zfs storage backend" sys-fs/zfs
	elog
	elog "Be sure to add your local user to the lxd group."
}
