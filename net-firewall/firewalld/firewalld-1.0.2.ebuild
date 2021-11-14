# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit autotools bash-completion-r1 gnome2-utils linux-info plocale python-single-r1 systemd xdg-utils

DESCRIPTION="A firewall daemon with D-BUS interface providing a dynamic firewall"
HOMEPAGE="http://www.firewalld.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="gui +nftables +iptables"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!!net-firewall/gshield
	iptables? (
		net-firewall/iptables[ipv6]
		net-firewall/ebtables
		net-firewall/ipset
		nftables? ( net-firewall/nftables[xtables(+)] )
	)
	|| ( >=sys-apps/openrc-0.11.5 sys-apps/systemd )
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		gui? (
			x11-libs/gtk+:3
			dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		)
		nftables? ( >=net-firewall/nftables-0.9.4[python,json] )
	')"
DEPEND="${RDEPEND}
	dev-libs/glib:2"
BDEPEND=">=dev-util/intltool-0.35
	sys-devel/gettext"

RESTRICT="test" # bug 650760

# Testsuite's Makefile.am calls missing(!)
# ... but this seems to be consistent with the autoconf docs?
# Needs more investigation: https://www.gnu.org/software/autoconf/manual/autoconf-2.67/html_node/autom4te-Invocation.html
QA_AM_MAINTAINER_MODE=".*--run autom4te --language=autotest.*"

PLOCALES="ar as ast bg bn_IN ca cs da de el en_GB en_US es et eu fa fi fr gl gu hi hu ia id it ja ka kn ko lt ml mr nl or pa pl pt pt_BR ru si sk sq sr sr@latin sv ta te tr uk zh_CN zh_TW"

pkg_setup() {
	local CONFIG_CHECK="~NF_CONNTRACK ~NETFILTER_XT_MATCH_CONNTRACK"

	# kernel >= 4.19 has unified a NF_CONNTRACK module, bug 692944
	if kernel_is -lt 4 19; then
		CONFIG_CHECK="${CONFIG_CHECK} ~NF_CONNTRACK_IPV4 ~NF_CONNTRACK_IPV6"
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default

	eautoreconf

	plocale_find_changes "po" "" ".po"
	plocale_get_locales | sed -e 's/ /\n/g' > po/LINGUAS
}

src_configure() {
	python_setup

	local econf_args=(
		--enable-systemd
		$(use_with iptables iptables "${EPREFIX}/sbin/iptables")
		$(use_with iptables iptables_restore "${EPREFIX}/sbin/iptables-restore")
		$(use_with iptables ip6tables "${EPREFIX}/sbin/ip6tables")
		$(use_with iptables ip6tables_restore "${EPREFIX}/sbin/ip6tables-restore")
		$(use_with iptables ebtables "${EPREFIX}/sbin/ebtables")
		$(use_with iptables ebtables_restore "${EPREFIX}/sbin/ebtables-restore")
		$(use_with iptables ipset "${EPREFIX}/usr/sbin/ipset")
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
		--with-bashcompletiondir="$(get_bashcompdir)"
	)

	econf "${econf_args[@]}"
}

src_install() {
	default
	python_optimize

	# Get rid of junk
	rm -rf "${D}/etc/sysconfig/" || die

	# For non-gui installs we need to remove GUI bits
	if ! use gui; then
		rm -rf "${D}/etc/xdg/autostart" || die
		rm -f "${D}/usr/bin/firewall-applet" || die
		rm -f "${D}/usr/bin/firewall-config" || die
		rm -rf "${D}/usr/share/applications" || die
		rm -rf "${D}/usr/share/icons" || die
	fi

	newinitd "${FILESDIR}"/firewalld.init firewalld
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
