# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"
EGO_PN_PARENT="github.com/lxc"
EGO_PN="${EGO_PN_PARENT}/lxd"
SRC_URI="http://961db08fe45d5f5dd062-b8a7a040508aea6d369676e49b80719d.r29.cf2.rackcdn.com/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PLOCALES="de fr ja"
IUSE="nls test +image"

# IUSE and PLOCALES must be defined before l10n inherited
inherit bash-completion-r1 eutils golang-build l10n systemd user vcs-snapshot

DEPEND="
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
	app-admin/cgmanager
	app-arch/xz-utils
	app-emulation/lxc[cgmanager]
	net-analyzer/openbsd-netcat
	net-misc/bridge-utils
	virtual/acl
	image? (
		app-crypt/gnupg
		>=dev-lang/python-3.2
	)
"

# KNOWN ISSUES:
# - Translations may not work.  I've been unsuccessful in forcing
#   localized output.  Anyway, upstream (Canonical) doesn't install the
#   message files.

src_prepare() {
	cd "${S}/src/${EGO_PN}"

	# Upstream requires the openbsd flavor of netcat (with -U), but
	# Gentoo installs that with a renamed binary
	epatch "${FILESDIR}/${P}-nc-binary-name.patch"

	# Warn on unhandled locale changes
	l10n_find_plocales_changes po "" .po
}

src_compile() {
	golang-build_src_compile

	cd "${S}/src/${EGO_PN}"

	# Build binaries
	GOPATH="${S}" emake

	use nls && emake build-mo
}

src_test() {
	# Go native tests should succeed
	golang-build_src_test
}

src_install() {
	# Installs all src,pkg to /usr/lib/go-gentoo
	golang-build_src_install

	cd "${S}"

	dobin bin/fuidshift
	dobin bin/lxc

	dosbin bin/lxd

	cd "src/${EGO_PN}"

	use image && dobin scripts/lxd-images

	if use nls; then
		for lingua in ${PLOCALES}; do
			if use linguas_${lingua}; then
				domo po/${lingua}.mo
			fi
		done
	fi

	newinitd "${FILESDIR}"/lxd.initd lxd
	newconfd "${FILESDIR}"/lxd.confd lxd

	systemd_dounit "${FILESDIR}"/lxd.service

	newbashcomp config/bash/lxc.in lxc

	dodoc AUTHORS CONTRIBUTING.md README.md

	docinto specs
	dodoc specs/*
}

pkg_config() {
	if brctl show lxcbr0 2>&1 | grep "No such device" >/dev/null; then
		brctl addbr lxcbr0
	fi
}

pkg_postinst() {
	# The control socket will be owned by (and writeable by) this group.
	enewgroup lxd

	# Ubuntu also defines an lxd user but it appears unused (the daemon
	# must run as root)

	# precedent: sys-libs/timezone-data
	pkg_config

	einfo
	einfo "To interact with the service as a non-root user, add yourself to the"
	einfo "lxd group.  This requires you to log out and log in again."
	einfo
}
