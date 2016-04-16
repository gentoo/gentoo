# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
COMMIT_ID="a82d9cfe03679b82ab4d9586c93ad377e9e27149"

inherit autotools-utils eutils flag-o-matic linux-info readme.gentoo-r1 systemd user vcs-snapshot

DESCRIPTION="A userspace logging daemon for netfilter/iptables related logging"
HOMEPAGE="https://netfilter.org/projects/ulogd/index.html"
SRC_URI="https://git.netfilter.org/${PN}2/snapshot/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="dbi doc json mysql nfacct +nfct +nflog pcap postgres sqlite -ulog"

RDEPEND="
	|| ( net-firewall/iptables net-firewall/nftables )
	>=net-libs/libnfnetlink-1.0.1
	dbi? ( dev-db/libdbi )
	json? ( dev-libs/jansson )
	nfacct? (
		>=net-libs/libmnl-1.0.3
		>=net-libs/libnetfilter_acct-1.0.1
	)
	nfct? ( >=net-libs/libnetfilter_conntrack-1.0.2 )
	nflog? ( >=net-libs/libnetfilter_log-1.0.0 )
	mysql? ( virtual/mysql )
	pcap? ( net-libs/libpcap )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	doc? (
		app-text/linuxdoc-tools
		app-text/texlive-core
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"

DOCS=( AUTHORS README TODO )

DOC_CONTENTS="
	You must have at least one logging stack enabled to make ulogd work.
	Please edit the example configuration located at /etc/ulogd.conf.
"

pkg_setup() {
	enewgroup ulogd
	enewuser ulogd -1 -1 /var/log/ulogd ulogd

	linux-info_pkg_setup

	if kernel_is lt 2 6 14; then
		die "${PN} requires a kernel >= 2.6.14."
	fi

	if use nfacct && kernel_is lt 3 3 0; then
		ewarn "NFACCT input plugin requires a kernel >= 3.3."
	fi

	if use ulog && kernel_is ge 3 17 0; then
		ewarn "ULOG target has been removed in the 3.17 kernel release."
		ewarn "Consider enabling NFACCT, NFCT, or NFLOG support instead."
	fi
}

src_prepare() {
	# - make all logs to be kept in a single dir /var/log/ulogd
	# - place sockets in /run instead of /tmp
	sed -i \
		-e "s%var/log%var/log/${PN}%g" \
		-e 's%tmp%run%g' \
		ulogd.conf.in || die

	append-lfs-flags
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with dbi)
		$(use_with json jansson)
		$(use_enable nfacct)
		$(use_enable nfct)
		$(use_enable nflog)
		$(use_with mysql)
		$(use_with pcap)
		$(use_with postgres pgsql)
		$(use_with sqlite)
		$(use_enable ulog)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		# Prevent access violations from bitmap font files generation
		export VARTEXFONTS="${T}"/fonts
		emake -C doc
	fi
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --modules
	readme.gentoo_create_doc

	if use doc; then
		dohtml doc/${PN}.html
		dodoc doc/${PN}.{dvi,ps,txt}
	fi

	use mysql && dodoc doc/mysql-*.sql
	use postgres && dodoc doc/pgsql-*.sql
	use sqlite && dodoc doc/sqlite3.table

	doman ${PN}.8

	insinto /etc
	doins "${BUILD_DIR}/${PN}.conf"
	fowners root:ulogd /etc/${PN}.conf
	fperms 640 /etc/${PN}.conf

	newinitd "${FILESDIR}/${PN}.init" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	diropts -o ulogd -g ulogd
	keepdir /var/log/ulogd
}

pkg_postinst() {
	readme.gentoo_print_elog
}
