# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"

# Maintained with https://github.com/hsoft/gentoo-ego-vendor-update
# The "# branch" comments are there for the script, they're important.
EGO_VENDOR=(
	"github.com/lxc/lxd e641ae45dc13cc27510c9d2127eece46ed9ac16b"
	"github.com/CanonicalLtd/go-sqlite3 730012cee3364e7717c28f7e9b05ee6dd8684bae"
	"github.com/CanonicalLtd/dqlite 9334841532709c77fc79e13a08408694e4bb3616"
	"github.com/CanonicalLtd/go-grpc-sql 534b56d0c689ed437e6cff44868964d45d3ec85c"
	"github.com/CanonicalLtd/raft-http e4290d0af830073ec140538e8974aa4393495ea1"
	"github.com/CanonicalLtd/raft-membership 26ef52960f54c472f52fb3701f19f25319e1032e"
	"github.com/CanonicalLtd/raft-test 22441a088d5630ddd2e971eae68074d2b645f1b7"
	"github.com/dustinkirkland/golang-petname d3c2ba80e75eeef10c5cf2fc76d2c809637376b3"
	"github.com/flosch/pongo2 97eac295f74b5fbb7fd3113e35f4ccf3c816e389"
	"github.com/juju/errors c7d06af17c68cd34c835053720b21f6549d9b0ee"
	"github.com/juju/idmclient 15392b0e99abe5983297959c737b8d000e43b34c"
	"github.com/juju/httprequest 77d36ac4b71a6095506c0617d5881846478558cb"
	"github.com/juju/utils d18e608d01400189bcda3e2669505cbd30e9dda9"
	"github.com/juju/loggo 7f1609ff1f3fcf3519ed62ccaaa9e609ea287838"
	"github.com/juju/webbrowser 54b8c57083b4afb7dc75da7f13e2967b2606a507"
	"github.com/juju/gomaasapi 663f786f595ba1707f56f62f7f4f2284c47c0f1d"
	"github.com/juju/schema e4f08199aa80d3194008c0bd2e14ef5edc0e6be6"
	"github.com/juju/version b64dbd566305c836274f0268fa59183a52906b36"
	"github.com/juju/persistent-cookiejar d5e5a8405ef9633c84af42fbcc734ec8dd73c198"
	"github.com/juju/go4 40d72ab9641a2a8c36a9c46a51e28367115c8e59"
	"github.com/juju/testing 43f926548f91d55be6bae26ecb7d2386c64e887c"
	"github.com/juju/retry 1998d01ba1c3eeb4a4728c4a50660025b2fe7c8f"
	"github.com/golang/protobuf e09c5db296004fbe3f74490e84dcd62c3c5ddb1b"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/gorilla/mux 4dbd923b0c9e99ff63ad54b0e9705ff92d3cdb06"
	"github.com/gorilla/websocket eb925808374e5ca90c83401a40d711dc08c0c0f6"
	"github.com/julienschmidt/httprouter d1898390779332322e6b5ca5011da4bf249bb056"
	"github.com/rogpeppe/fastuuid 6724a57986aff9bff1a1770e9347036def7c89f6"
	"github.com/pkg/errors 816c9085562cd7ee03e7f8188a1cfd942858cded"
	"github.com/ryanfaerman/fsm 3dc1bc0980272fd56d81167a48a641dab8356e29"
	"github.com/hashicorp/raft a3fb4581fb07b16ecf1c3361580d4bdb17de9d98"
	"github.com/hashicorp/go-immutable-radix 7f3cd4390caab3250a57f30efdb2a65dd7649ecf"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/raft-boltdb 6e5ba93211eaf8d9a2ad7e41ffad8c6f160f9fe3"
	"github.com/armon/go-metrics 783273d703149aaeb9897cf58613d5af48861c25"
	"github.com/stretchr/testify c679ae2cc0cb27ec3293fea7e254e47386f05d69"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/mattn/go-colorable efa589957cd060542a26d2dd7832fd6a6c6c3ade"
	"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
	"github.com/mattn/go-runewidth a9d6d1e4dc51df2130326793d49971f238839169"
	"github.com/syndtr/gocapability 33e07d32887e1e06b7c025f27ce52f62c7990bc0"
	"github.com/pborman/uuid c65b2f87fee37d1c7854c9164a450713c28d50cd"
	"github.com/spf13/cobra 4dab30cb33e6633c33c787106bafbfbfdde7842d"
	"github.com/spf13/pflag 1cd4a0c365d95803411bec89fb7b76bade17053b"
	"github.com/cpuguy83/go-md2man 48d8747a2ca13185e7cc8efe6e9fc196a83f71a5"
	"github.com/gosexy/gettext 74466a0a0c4a62fea38f44aa161d4bbfbe79dd6b"
	"github.com/frankban/quicktest 536e76da5efc46dc247088384c2d2cea7da968aa"
	"github.com/google/go-cmp 5411ab924f9ffa6566244a9e504bc347edacffd3"
	"github.com/kr/pretty cfb55aafdaf3ec08f0db22699ab822c50091b1c4"
	"github.com/kr/text 7cafcd837844e784b526369c9bce262804aebc60"
	"github.com/olekukonko/tablewriter b8a9be070da40449e501c3c4730a889e42d87a9e"
	"google.golang.org/genproto ab0870e398d5dd054b868c0db1481ab029b9a9f2 github.com/google/go-genproto"
	"google.golang.org/grpc 2dfcc11f7a6d4791ba627222d783eedf268b4b95 github.com/grpc/grpc-go"
	"golang.org/x/crypto 12892e8c234f4fe6f6803f052061de9057903bb2 github.com/golang/crypto"
	"golang.org/x/net b68f30494add4df6bd8ef5e82803f308e7f7c59c github.com/golang/net"
	"golang.org/x/sys 378d26f46672a356c46195c28f61bdb4c0a781dd github.com/golang/sys"
	"golang.org/x/text ece95c760240037f89ebcbdd7155ac8cb52e38fa github.com/golang/text"
	"gopkg.in/errgo.v1 442357a80af5c6bf9b6d51ae791a39c3421004f3 github.com/go-errgo/errgo" # branch v1
	"gopkg.in/juju/names.v2 54f00845ae470a362430a966fe17f35f8784ac92 github.com/juju/names" # branch v2
	"gopkg.in/juju/environschema.v1 7359fc7857abe2b11b5b3e23811a9c64cb6b01e0 github.com/juju/environschema" # branch v1
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml" # branch v2.2.1
	"gopkg.in/macaroon-bakery.v2 94012773d2874a067572bd16d7d11ae02968b47b github.com/go-macaroon-bakery/macaroon-bakery" # branch v2.0.1
	"gopkg.in/macaroon.v2 bed2a428da6e56d950bed5b41fcbae3141e5b0d0 github.com/go-macaroon/macaroon" # branch v2.0.0
	"gopkg.in/httprequest.v1 1a21782420ea13c3c6fb1d03578f446b3248edb1 github.com/go-httprequest/httprequest" # branch v1.1.1
	"gopkg.in/lxc/go-lxc.v2 2660c429a942a4a21455765c7046dde612c1baa7 github.com/lxc/go-lxc" # branch v2
	"gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c github.com/go-tomb/tomb" # branch v2
	"gopkg.in/mgo.v2 3f83fa5005286a7fe593b055f0d7771a7dce4655 github.com/go-mgo/mgo" # branch v2
	"gopkg.in/retry.v1 2d7c7c65cc71d024968d9ff4385d5e7ad3a83fcc github.com/go-retry/retry" # branch v1.0.0
	"gopkg.in/check.v1 20d25e2804050c1cd24a7eea1e7a6447dd0e74ec github.com/go-check/check" # branch v1
)

ARCHIVE_URI="https://${EGO_PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+daemon +ipv6 +dnsmasq nls test"

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
		dnsmasq? (
			net-dns/dnsmasq[dhcp,ipv6?]
		)
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
	"${FILESDIR}/${PN}-dont-go-get.patch"
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
	else
		einfo "No tests to run for client-only builds"
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
		newinitd "${FILESDIR}"/${PN}.initd lxd
		newconfd "${FILESDIR}"/${PN}.confd lxd

		systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	fi

	newbashcomp scripts/bash/lxd-client lxc

	dodoc AUTHORS README.md doc/*
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
