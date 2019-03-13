# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=9d91ab6a8e6bc2b41e985aa698eb5c1eb364fea8
MY_PN="peerguardian"
MY_P="${MY_PN}-${PV}"
inherit autotools gnome2-utils linux-info systemd

DESCRIPTION="Privacy oriented firewall application"
HOMEPAGE="https://sourceforge.net/projects/peerguardian/"
SRC_URI="https://sourceforge.net/code-snapshots/git/p/pe/peerguardian/code.git/peerguardian-code-${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cron dbus logrotate networkmanager qt5 zlib"
REQUIRED_USE="qt5? ( dbus )"

COMMON_DEPEND="
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	dbus? ( sys-apps/dbus )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		|| ( kde-plasma/kde-cli-tools[kdesu] x11-misc/ktsuss )
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/libtool:2
"
RDEPEND="${COMMON_DEPEND}
	net-firewall/iptables
	sys-apps/sysvinit
	cron? ( virtual/cron )
	logrotate? ( app-admin/logrotate )
	networkmanager? ( net-misc/networkmanager:= )
"

CONFIG_CHECK="~NETFILTER_NETLINK
	~NETFILTER_NETLINK_QUEUE
	~NETFILTER_XTABLES
	~NETFILTER_XT_TARGET_NFQUEUE
	~NETFILTER_XT_MATCH_IPRANGE
	~NETFILTER_XT_MARK
	~NETFILTER_XT_MATCH_MULTIPORT
	~NETFILTER_XT_MATCH_STATE
	~NF_CONNTRACK
	~NF_CONNTRACK_IPV4
	~NF_DEFRAG_IPV4
	~IP_NF_FILTER
	~IP_NF_IPTABLES
	~IP_NF_TARGET_REJECT"

S="${WORKDIR}/${MY_PN}-code-${COMMIT}"

src_prepare() {
	default
	sed -e 's:/sbin/runscript:/sbin/openrc-run:' \
		-i pglcmd/init/pgl.gentoo.in || die "Failed to convert to openrc-run"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-lowmem
		--with-iconsdir=/usr/share/icons/hicolor/128x128/apps
		--with-gentoo-init
		--localstatedir=/var
		$(use_enable cron)
		$(use_enable dbus)
		$(use_enable logrotate)
		$(use_enable networkmanager)
		$(use_with qt5)
		$(use_enable zlib)
		--with-systemd="$(systemd_get_systemunitdir)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/{lib,log,spool}/pgl
	rm -rf "${ED%/}"/tmp || die
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Optional dependencies:"
	elog "  app-arch/p7zip (needed for blocklists packed as .7z)"
	elog "  app-arch/unzip (needed for blocklists packed as .zip)"
	elog "  virtual/mta (needed to send informational (blocklist updates) and"
	elog "    warning mails (if pglcmd.wd detects a problem.))"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
