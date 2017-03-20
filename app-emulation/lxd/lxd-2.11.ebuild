# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"

# The source is repackaged using a script at:
#   https://dev.gentoo.org/~stasibear/lxd_repackage.py
# This is necessary because go's native package management assumes
# that a build starts with checking out many git repositories, often
# from HEAD.  This provides no way to build the same code repeatably,
# and anyway portage requires that fetching is only done from SRC_URI.
# The only sane alternative I've seen is in the consul ebuild, which
# is more transparent but raises other questions.
SRC_URI="https://dev.gentoo.org/~stasibear/distfiles/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PLOCALES="de el fr ja nl ru"
IUSE="+daemon nls test"

# IUSE and PLOCALES must be defined before l10n inherited
inherit bash-completion-r1 golang-build l10n linux-info systemd user vcs-snapshot

DEPEND="
	>=dev-lang/go-1.7.1
	dev-go/go-crypto
	dev-go/go-net
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

PATCHES=("${FILESDIR}/${P}-dont-go-get.patch")

# KNOWN ISSUES:
# - Translations may not work.  I've been unsuccessful in forcing
#   localized output.  Anyway, upstream (Canonical) doesn't install the
#   message files.

src_prepare() {
	cd "${S}/src/${EGO_PN}" || die "Failed to change to deep src dir"

	default_src_prepare

	tmpgoroot="${T}/goroot"
	mkdir -p "$tmpgoroot" || die "Failed to create temporary GOROOT"
	cp -sR "$(get_golibdir_gopath)"/* "${tmpgoroot}" || die "Failed to copy files to temporary GOROOT"

	# Warn on unhandled locale changes
	l10n_find_plocales_changes po "" .po
}

src_compile() {
	golang-build_src_compile

	cd "${S}/src/${EGO_PN}" || die "Failed to change to deep src dir"

	tmpgoroot="${T}/goroot"
	if use daemon; then
		# Build binaries
		GOPATH="${S}:${tmpgoroot}" emake
	else
		# build client tool
		GOPATH="${S}:${tmpgoroot}" emake client
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

		systemd_dounit "${FILESDIR}"/${P}.service
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
