# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"
SRC_URI="https://dev.gentoo.org/~stasibear/distfiles/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PLOCALES="de fr ja"
IUSE="+daemon nls test"

# IUSE and PLOCALES must be defined before l10n inherited
inherit bash-completion-r1 eutils golang-build l10n systemd user vcs-snapshot

DEPEND="
	dev-go/go-crypto
	>=dev-lang/go-1.4.2:=
	dev-libs/protobuf
	dev-vcs/git
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
		app-admin/cgmanager
		app-arch/xz-utils
		app-emulation/lxc[cgmanager,seccomp]
		net-analyzer/openbsd-netcat
		net-misc/bridge-utils
		net-misc/rsync[xattr]
		sys-apps/iproute2
		virtual/acl
	)
"

# KNOWN ISSUES:
# - Translations may not work.  I've been unsuccessful in forcing
#   localized output.  Anyway, upstream (Canonical) doesn't install the
#   message files.

# TODO:
# - since 0.15 gccgo is a supported compiler ('make gccgo').  It would
#   be preferable for that support to go into the golang-build eclass not
#   this package directly.
# - integrate "lxd shutdown" into initscript as custom action (default "stop"
#   action should _not_ stop containers amirite?)
#   "Perform a clean shutdown of LXD and all running containers"

src_prepare() {
	cd "${S}/src/${EGO_PN}"

	epatch "${FILESDIR}/${P}-dont-go-get.patch"

	# Upstream requires the openbsd flavor of netcat (with -U), but
	# Gentoo installs that with a renamed binary
	epatch "${FILESDIR}/${P}-nc-binary-name.patch"

	# Warn on unhandled locale changes
	l10n_find_plocales_changes po "" .po
}

src_compile() {
	golang-build_src_compile

	cd "${S}/src/${EGO_PN}"

	if use daemon; then
		# Build binaries
		GOPATH="${S}:$(get_golibdir_gopath)" emake
	else
		# build client tool
		GOPATH="${S}:$(get_golibdir_gopath)" emake client
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
		dobin bin/fuidshift

		dosbin bin/lxd
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

		systemd_dounit "${FILESDIR}"/lxd.service
	fi

	newbashcomp config/bash/lxc.in lxc

	dodoc AUTHORS CONTRIBUTING.md README.md

	docinto specs
	dodoc specs/*
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
	einfo "- sys-fs/zfs"
	einfo "- sys-process/criu"
	einfo
	einfo "Since these features can't be disabled at build-time they are"
	einfo "not USE-conditional."

	if test -n "${REPLACING_VERSIONS}"; then
		einfo
		einfo "If you are upgrading from version 0.14 or older, note that the --tcp"
		einfo "is no longer available in /etc/conf.d/lxd.  Instead, configure the"
		einfo "listen address/port by setting the core.https_address server option."
	fi

	einfo
}
