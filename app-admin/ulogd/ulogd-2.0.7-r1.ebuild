# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic linux-info readme.gentoo-r1 systemd user

DESCRIPTION="A userspace logging daemon for netfilter/iptables related logging"
HOMEPAGE="https://netfilter.org/projects/ulogd/index.html"
SRC_URI="https://www.netfilter.org/projects/ulogd/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE="dbi doc json mysql nfacct +nfct +nflog pcap postgres selinux sqlite ulog"

COMMON_DEPEND="
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
	mysql? ( dev-db/mysql-connector-c:= )
	pcap? ( net-libs/libpcap )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${COMMON_DEPEND}
	doc? (
		app-text/linuxdoc-tools
		app-text/texlive-core
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-ulogd )
"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
You must have at least one logging stack enabled to make ulogd work.
Please edit the example configuration located at '${EPREFIX}/etc/ulogd.conf'.
"

pkg_setup() {
	linux-info_pkg_setup

	if use nfacct && kernel_is lt 3 3 0; then
		ewarn "NFACCT input plugin requires a kernel >= 3.3."
	fi

	if use ulog && kernel_is ge 3 17 0; then
		ewarn "ULOG target has been removed in the 3.17 kernel release."
		ewarn "Consider enabling NFACCT, NFCT, or NFLOG support instead."
	fi

	enewgroup ulogd
	enewuser ulogd -1 -1 /var/log/ulogd ulogd
}

src_prepare() {
	default_src_prepare

	# Change default settings to:
	# - keep log files in /var/log/ulogd instead of /var/log;
	# - create sockets in /run instead of /tmp.
	sed -i \
		-e "s|var/log|var/log/${PN}|g" \
		-e 's|tmp|run|g' \
		ulogd.conf.in || die
}

src_configure() {
	append-lfs-flags
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
	econf "${myeconfargs[@]}"
}

src_compile() {
	default_src_compile

	if use doc; then
		# Prevent access violations from bitmap font files generation.
		export VARTEXFONTS="${T}/fonts"
		emake -C doc
	fi
}

src_install() {
	use doc && HTML_DOCS=( doc/${PN}.html )

	default_src_install
	find "${D}" -name '*.la' -delete || die

	readme.gentoo_create_doc
	doman ${PN}.8

	use doc && dodoc doc/${PN}.{dvi,ps,txt}
	use mysql && dodoc doc/mysql-*.sql
	use postgres && dodoc doc/pgsql-*.sql
	use sqlite && dodoc doc/sqlite3.table

	insinto /etc
	doins ${PN}.conf
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
