# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"

# Maintained with https://github.com/hsoft/gentoo-ego-vendor-update
EGO_VENDOR=(
	"github.com/dustinkirkland/golang-petname 1f4996aa8aa05ee066aaf9e3179d340b48c6da74"
	"github.com/golang/protobuf 17ce1425424ab154092bbb43af630bd647f3bb0d"
	"github.com/gorilla/mux bb285ea687c5c77bb6935fdb2402b121d8efcbec"
	"github.com/gorilla/websocket a69d9f6de432e2c6b296a947d8a5ee88f68522cf"
	"github.com/gosexy/gettext 74466a0a0c4a62fea38f44aa161d4bbfbe79dd6b"
	"github.com/jessevdk/go-flags 6cf8f02b4ae8ba723ddc64dcfd403e530c06d927"
	"github.com/mattn/go-colorable ad5389df28cdac544c99bd7b9161a0b5b6ca9d1b"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
	"github.com/mattn/go-sqlite3 05548ff55570cdb9ac72ff4a25a3b5e77a6fb7e5"
	"github.com/olekukonko/tablewriter be5337e7b39e64e5f91445ce7e721888dbab7387"
	"github.com/pborman/uuid e790cca94e6cc75c7064b1332e63811d4aae1a53"
	"github.com/stretchr/testify 890a5c3458b43e6104ff5da8dfa139d013d77544"
	"github.com/syndtr/gocapability db04d3cc01c8b54962a58ec7e491717d06cfcc16"
	"github.com/go-stack/stack 817915b46b97fd7bb80e8ab6b69f01a53ac3eebf"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/juju/errors c7d06af17c68cd34c835053720b21f6549d9b0ee"
	"golang.org/x/crypto 81e90905daefcd6fd217b62423c0908922eadb30 github.com/golang/crypto"
	"golang.org/x/net 66aacef3dd8a676686c7ae3716979581e8b03c47 github.com/golang/net"
	"golang.org/x/sync f52d1811a62927559de87708c8913c1650ce4f26 github.com/golang/sync"
	"golang.org/x/text bd91bbf73e9a4a801adbfb97133c992678533126 github.com/golang/text"
	"golang.org/x/tools 3b1faeda9afbcba128c2d794b38ffe7982141139 github.com/golang/tools"
	"golang.org/x/sys 7ddbeae9ae08c6a06a59597f0c9edbc5ff2444ce github.com/golang/sys"
	"gopkg.in/check.v1 20d25e2804050c1cd24a7eea1e7a6447dd0e74ec github.com/go-check/check"
	"gopkg.in/flosch/pongo2.v3 5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9 github.com/flosch/pongo2"
	"gopkg.in/inconshreveable/log15.v2 b105bd37f74e5d9dc7b6ad7806715c7a2b83fd3f github.com/inconshreveable/log15"
	"gopkg.in/lxc/go-lxc.v2 edfe59cec27b76afeb3b35c56f2948c27afac493 github.com/lxc/go-lxc"
	"gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 eb3733d160e74a9c7e442f435eb3bea458e1d19f github.com/go-yaml/yaml"
)

ARCHIVE_URI="https://${EGO_PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+daemon +ipv6 nls test"

inherit bash-completion-r1 linux-info systemd user golang-vcs-snapshot

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

DEPEND="
	>=dev-lang/go-1.7.1
	dev-libs/protobuf
	nls? ( sys-devel/gettext )
	test? (
		app-misc/jq
		dev-db/sqlite
		net-misc/curl
		sys-devel/gettext
	)
"

RDEPEND="
	daemon? (
		app-arch/xz-utils
		>=app-emulation/lxc-2.0.7[seccomp]
		net-dns/dnsmasq[dhcp,ipv6?]
		net-misc/rsync[xattr]
		sys-apps/iproute2[ipv6?]
		sys-fs/squashfs-tools
		virtual/acl
	)
"

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

ERROR_BRIDGE="BRIDGE: needed for network commands"
ERROR_DUMMY="DUMMY: needed for network commands"
ERROR_IP6_NF_NAT="IP6_NF_NAT: needed for network commands"
ERROR_IP6_NF_TARGET_MASQUERADE="IP6_NF_TARGET_MASQUERADE: needed for network commands"
ERROR_IPV6="IPV6: needed for network commands"
ERROR_IP_NF_NAT="IP_NF_NAT: needed for network commands"
ERROR_IP_NF_TARGET_MASQUERADE="IP_NF_TARGET_MASQUERADE: needed for network commands"
ERROR_MACVLAN="MACVLAN: needed for network commands"
ERROR_NETFILTER_XT_MATCH_COMMENT="NETFILTER_XT_MATCH_COMMENT: needed for network commands"
ERROR_NET_IPGRE="NET_IPGRE: needed for network commands"
ERROR_NET_IPGRE_DEMUX="NET_IPGRE_DEMUX: needed for network commands"
ERROR_NET_IPIP="NET_IPIP: needed for network commands"
ERROR_NF_NAT_MASQUERADE_IPV4="NF_NAT_MASQUERADE_IPV4: needed for network commands"
ERROR_NF_NAT_MASQUERADE_IPV6="NF_NAT_MASQUERADE_IPV6: needed for network commands"
ERROR_VXLAN="VXLAN: needed for network commands"

PATCHES=(
	"${FILESDIR}/${P}-dont-go-get.patch"
)

src_prepare() {
	default_src_prepare

	# Examples in go-lxc make our build fail.
	rm -rf "${S}/src/${EGO_PN}/vendor/gopkg.in/lxc/go-lxc.v2/examples" || die
}

src_compile() {
	export GOPATH="${S}"

	cd "${S}/src/${EGO_PN}" || die "Failed to change to deep src dir"

	tmpgoroot="${T}/goroot"
	if use daemon; then
		# Build binaries
		emake
	else
		# build client tool
		emake client
	fi

	use nls && emake build-mo
}

src_test() {
	if use daemon; then
		export GOPATH="${S}"
		cd "${S}/src/${EGO_PN}" || die "Failed to change to deep src dir"

		emake check
	fi
}

src_install() {
	dobin bin/lxc
	if use daemon; then
		dosbin bin/lxd
		dobin bin/fuidshift
	fi

	cd "src/${EGO_PN}" || die "can't cd into ${S}/src/${EGO_PN}"

	if use nls; then
		domo po/*.mo
	fi

	if use daemon; then
		newinitd "${FILESDIR}"/${P}.initd lxd
		newconfd "${FILESDIR}"/${P}.confd lxd

		systemd_newunit "${FILESDIR}"/${P}.service ${PN}.service
	fi

	newbashcomp config/bash/lxd-client lxc

	dodoc AUTHORS CONTRIBUTING.md README.md doc/*
}

pkg_postinst() {
	einfo
	einfo "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	einfo "including a Quick Start."

	# The messaging below only applies to daemon installs
	use daemon || return 0

	# The control socket will be owned by (and writeable by) this group.
	enewgroup lxd

	# Ubuntu also defines an lxd user but it appears unused (the daemon
	# must run as root)

	einfo
	einfo "Though not strictly required, some features are enabled at run-time"
	einfo "when the relevant helper programs are detected:"
	einfo "- sys-apps/apparmor"
	einfo "- sys-fs/btrfs-progs"
	einfo "- sys-fs/lvm2"
	einfo "- sys-fs/lxcfs"
	einfo "- sys-fs/zfs"
	einfo "- sys-process/criu"
	einfo
	einfo "Since these features can't be disabled at build-time they are"
	einfo "not USE-conditional."
	einfo
	einfo "Networks with bridge.mode=fan are unsupported due to requiring"
	einfo "a patched kernel and iproute2."
}
