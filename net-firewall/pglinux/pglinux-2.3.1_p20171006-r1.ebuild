# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=9d91ab6a8e6bc2b41e985aa698eb5c1eb364fea8
MY_PN="peerguardian"
MY_P="${MY_PN}-${PV}"
inherit autotools qmake-utils linux-info systemd xdg-utils

DESCRIPTION="Privacy oriented firewall application"
HOMEPAGE="https://sourceforge.net/projects/peerguardian/"
SRC_URI="https://sourceforge.net/code-snapshots/git/p/pe/peerguardian/code.git/peerguardian-code-${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cron dbus networkmanager qt5 zlib"
REQUIRED_USE="qt5? ( dbus )"

DEPEND="
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	dbus? ( sys-apps/dbus )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		|| (
			kde-plasma/kde-cli-tools:*[kdesu]
			x11-misc/ktsuss
		)
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}
	net-firewall/iptables
	sys-apps/sysvinit
	cron? ( virtual/cron )
	networkmanager? ( net-misc/networkmanager:= )
"
BDEPEND="
	app-arch/unzip
	sys-devel/libtool:2
	virtual/pkgconfig
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

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

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
		--enable-logrotate
		$(use_enable cron)
		$(use_enable dbus)
		$(use_enable networkmanager)
		$(use_with qt5)
		LRELEASE=$(qt5_get_bindir)/lrelease
		LUPDATE=$(qt5_get_bindir)/lupdate
		MOC=$(qt5_get_bindir)/moc
		QMAKE=$(qt5_get_bindir)/qmake
		RCC=$(qt5_get_bindir)/rcc
		UIC=$(qt5_get_bindir)/uic
		$(use_enable zlib)
		--with-systemd="$(systemd_get_systemunitdir)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/{lib,log,spool}/pgl
	rm -rf "${ED}"/tmp || die
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Optional dependencies:"
	elog "  app-arch/p7zip (needed for blocklists packed as .7z)"
	elog "  app-arch/unzip (needed for blocklists packed as .zip)"
	elog "  virtual/mta (needed to send informational (blocklist updates) and"
	elog "    warning mails (if pglcmd.wd detects a problem.))"

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
