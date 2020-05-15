# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 eutils linux-info systemd

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/ https://github.com/lxc/lxd"
SRC_URI="https://linuxcontainers.org/downloads/${PN}/${P}.tar.gz"

# Needs to include licenses for all bundled programs.
LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ipv6 nls"

DEPEND="app-arch/xz-utils
	>=app-emulation/lxc-3.0.0[seccomp]
	dev-lang/tcl
	dev-libs/libuv
	dev-libs/lzo
	net-dns/dnsmasq[dhcp,ipv6?]"
RDEPEND="${DEPEND}
	acct-group/lxd
	net-firewall/ebtables
	net-firewall/iptables[ipv6?]
	sys-apps/iproute2[ipv6?]
	sys-fs/fuse:0=
	sys-fs/lxcfs
	sys-fs/squashfs-tools
	virtual/acl"
BDEPEND="dev-lang/go
	nls? ( sys-devel/gettext )"

CONFIG_CHECK="
	~BRIDGE
	~DUMMY
	~IP6_NF_NAT
	~IP6_NF_TARGET_MASQUERADE
	~IPV6
	~IP_NF_NAT
	~IP_NF_TARGET_MASQUERADE
	~MACVLAN
	~NETFILTER_XT_MATCH_COMMENT
	~NET_IPGRE
	~NET_IPGRE_DEMUX
	~NET_IPIP
	~NF_NAT_MASQUERADE_IPV4
	~NF_NAT_MASQUERADE_IPV6
	~VXLAN
"

# To no one's surprise uses internet connection.
RESTRICT="test"

# Go magic.
QA_PREBUILT="/usr/lib/lxd/libdqlite.so.0.0.1
	/usr/bin/fuidshift
	/usr/bin/lxc
	/usr/bin/lxc-to-lxd
	/usr/bin/lxd-agent
	/usr/bin/lxd-benchmark
	/usr/bin/lxd-p2c
	/usr/sbin/lxd"

EGO_PN="github.com/lxc/lxd"
GOPATH="${S}/_dist" # this seems to reset every now and then, though

common_op() {
	local i
	for i in dqlite raft; do
		cd "${GOPATH}"/deps/${i} || die "failed to switch dir to ${i}"
		"${@}"
		cd "${S}" || die "failed to switch dir back from ${i} to ${S}"
	done
}

src_prepare() {
	default

	export GOPATH="${S}/_dist"

	sed -i \
		-e "s:\./configure:./configure --prefix=/usr --libdir=${EPREFIX}/usr/lib/lxd:g" \
		-e "s:make:make ${MAKEOPTS}:g" \
		Makefile || die

	sed -i 's#lib$#lib/lxd#' "${GOPATH}"/deps/libco/Makefile || die
	sed -i 's#zfs version 2>/dev/null | cut -f 2 -d - | head -1#< /sys/module/zfs/version cut -f 1#' "${GOPATH}"/deps/raft/configure.ac || die

	common_op eautoreconf
}

src_configure() {
	export GOPATH="${S}/_dist"

	export CO_CFLAGS="-I${GOPATH}/deps/libco/"
	export CO_LIBS="${GOPATH}/deps/libco/"

	export RAFT_CFLAGS="-I${GOPATH}/deps/raft/include/"
	export RAFT_LIBS="${GOPATH}/deps/raft/.libs"

	export SQLITE_CFLAGS="-I${GOPATH}/deps/sqlite"
	export SQLITE_LIBS="${GOPATH}/deps/sqlite/.libs"

	export PKG_CONFIG_PATH="${GOPATH}/sqlite/:${GOPATH}/libco/:${GOPATH}/raft/"

	cd "${GOPATH}/deps/sqlite" || die
	econf --enable-replication --disable-amalgamation --disable-tcl --libdir="${EPREFIX}/usr/lib/lxd"

	common_op econf --libdir="${EPREFIX}"/usr/lib/lxd
}

src_compile() {
	export GOPATH="${S}/_dist"

	export CGO_CFLAGS="${CGO_CFLAGS} -I${GOPATH}/deps/sqlite/ -I${GOPATH}/deps/dqlite/include/ -I${GOPATH}/deps/raft/include/ -I${GOPATH}/deps/libco/"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L${GOPATH}/deps/sqlite/.libs/ -L${GOPATH}/deps/dqlite/.libs/ -L${GOPATH}/deps/raft/.libs -L${GOPATH}/deps/libco/ -Wl,-rpath,${EPREFIX}/usr/lib/lxd"
	export LD_LIBRARY_PATH="${GOPATH}/deps/sqlite/.libs/:${GOPATH}/deps/dqlite/.libs/:${GOPATH}/deps/raft/.libs:${GOPATH}/deps/libco/:${LD_LIBRARY_PATH}"

	local j
	for j in sqlite raft libco; do
		cd "${GOPATH}"/deps/${j} || die
		emake
	done

	ln -s libco.so.0.1.0 libco.so || die

	cd "${GOPATH}/deps/dqlite" || die
	emake CFLAGS="-I${GOPATH}/deps/sqlite -I${GOPATH}/deps/raft/include" LDFLAGS="-L${GOPATH}/deps/sqlite -L${GOPATH}/deps/raft"

	cd "${S}" || die

	for k in fuidshift lxd-agent lxd-benchmark lxd-p2c lxc lxc-to-lxd; do
		go install -v -x ${EGO_PN}/${k} || die "failed compiling ${k}"
	done

	go install -v -x -tags libsqlite3 ${EGO_PN}/lxd || die "Failed to build the daemon"

	use nls && emake build-mo
}

src_test() {
	export GOPATH="${S}/_dist"

	# This is mostly a copy/paste from the Makefile's "check" rule, but
	# patching the Makefile to work in a non "fully-qualified" go namespace
	# was more complicated than this modest copy/paste.
	# Also: sorry, for now a network connection is needed to run tests.
	# Will properly bundle test dependencies later.
	go get -v -x github.com/rogpeppe/godeps || die
	go get -v -x github.com/remyoudompheng/go-misc/deadcode || die
	go get -v -x github.com/golang/lint/golint || die
	go test -v ${EGO_PN}/lxd || die
}

src_install() {
	local bindir="_dist/bin"
	export GOPATH="${S}/_dist"

	dosbin ${bindir}/lxd

	for l in fuidshift lxd-agent lxd-benchmark lxd-p2c lxc lxc-to-lxd; do
		dobin ${bindir}/${l}
	done

	for m in dqlite libco raft sqlite; do
		cd "${GOPATH}"/deps/${m} || die "failed switching into ${GOPATH}/${m}"
		emake DESTDIR="${D}" install
	done

	cd "${S}" || die

	# We only need libraries, and we don't want anything to link against these.
	rm "${ED}"/usr/bin/sqlite3 || die
	rm -r "${ED}"/usr/include || die
	rm -r "${ED}"/usr/lib/lxd/*.a || die
	rm -r "${ED}"/usr/lib/lxd/pkgconfig || die

	newbashcomp scripts/bash/lxd-client lxc

	newconfd "${FILESDIR}"/${PN}-4.0.0.confd lxd
	newinitd "${FILESDIR}"/${PN}-4.0.0.initd lxd

	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service

	dodoc AUTHORS doc/*
	use nls && domo po/*.mo
}

pkg_postinst() {
	elog
	elog "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	elog "including a Quick Start."
	elog
	elog "Optional features:"
	optfeature "apparmor support" app-emulation/lxc[apparmor]
	optfeature "btrfs storage backend" sys-fs/btrfs-progs
	optfeature "lvm2 storage backend" sys-fs/lvm2
	optfeature "zfs storage backend" sys-fs/zfs
	elog
	elog "Be sure to add your local user to the lxd group."
}
