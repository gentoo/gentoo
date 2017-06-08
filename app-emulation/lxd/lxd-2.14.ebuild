# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"
EGIT_COMMIT="4c32a1ff7267d4934870e2444dc1394fea5a78e4"
EGO_VENDOR=(
	"github.com/dustinkirkland/golang-petname 1f4996aa8aa05ee066aaf9e3179d340b48c6da74"
	"github.com/golang/protobuf 5a0f697c9ed9d68fef0116532c6e05cfeae00e55"
	"github.com/gorilla/mux 18fca31550181693b3a834a15b74b564b3605876"
	"github.com/gorilla/websocket a91eba7f97777409bc2c443f5534d41dd20c5720"
	"github.com/gosexy/gettext 74466a0a0c4a62fea38f44aa161d4bbfbe79dd6b"
	"github.com/jessevdk/go-flags 5695738f733662da3e9afc2283bba6f3c879002d"
	"github.com/mattn/go-colorable ded68f7a9561c023e790de24279db7ebf473ea80"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
	"github.com/mattn/go-sqlite3 83772a7051f5e30d8e59746a9e43dfa706b72f3b"
	"github.com/olekukonko/tablewriter febf2d34b54a69ce7530036c7503b1c9fbfdf0bb"
	"github.com/pborman/uuid 1b00554d822231195d1babd97ff4a781231955c9"
	"github.com/stretchr/testify f6abca593680b2315d2075e0f5e2a9751e3f431a"
	"github.com/syndtr/gocapability e7cb7fa329f456b3855136a2642b197bad7366ba"
	"golang.org/x/crypto e1a4589e7d3ea14a3352255d04b6f1a418845e5e github.com/golang/crypto"
	"golang.org/x/net e4fa1c5465ad6111f206fc92186b8c83d64adbe1 github.com/golang/net"
	"golang.org/x/sync f52d1811a62927559de87708c8913c1650ce4f26 github.com/golang/sync"
	"golang.org/x/text ccbd3f7822129ff389f8ca4858a9b9d4d910531c github.com/golang/text"
	"golang.org/x/tools 2a5864fcfb595b4ee9a7607f1beb25778cf64c6e github.com/golang/tools"
	"gopkg.in/check.v1 20d25e2804050c1cd24a7eea1e7a6447dd0e74ec github.com/go-check/check"
	"gopkg.in/flosch/pongo2.v3 5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9 github.com/flosch/pongo2"
	"gopkg.in/inconshreveable/log15.v2 b105bd37f74e5d9dc7b6ad7806715c7a2b83fd3f github.com/inconshreveable/log15"
	"gopkg.in/lxc/go-lxc.v2 de2c8bfd65a78752d6a70b4ad99114c6969363b0 github.com/lxc/go-lxc"
	"gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b github.com/go-yaml/yaml"
)

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PLOCALES="de el fr it ja nl ru sr sv tr"
IUSE="+daemon nls test"

# IUSE and PLOCALES must be defined before l10n inherited
inherit bash-completion-r1 golang-build l10n linux-info systemd user golang-vcs-snapshot

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
		app-emulation/lxc[seccomp]
		net-dns/dnsmasq[dhcp,ipv6]
		net-misc/rsync[xattr]
		sys-apps/iproute2[ipv6]
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
	# See https://github.com/lxc/lxd/pull/3390
	"${FILESDIR}/${P}-fix-fr-po.patch"
)

# KNOWN ISSUES:
# - Translations may not work.  I've been unsuccessful in forcing
#   localized output.  Anyway, upstream (Canonical) doesn't install the
#   message files.

src_prepare() {
	default_src_prepare

	# Warn on unhandled locale changes
	l10n_find_plocales_changes "${S}/src/${EGO_PN}/po" "" .po

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
		# Go native tests should succeed
		golang-build_src_test
	fi
}

src_install() {
	# Installs all src,pkg to /usr/lib/go-gentoo
	golang-build_src_install

	cd "${S}"
	dobin bin/lxc
	if use daemon; then
		dosbin bin/lxd
		dobin bin/fuidshift
	fi

	cd "src/${EGO_PN}"

	if use nls; then
		for lingua in ${PLOCALES}; do
			if use linguas_${lingua}; then
				domo po/${lingua}.mo
			fi
		done
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
