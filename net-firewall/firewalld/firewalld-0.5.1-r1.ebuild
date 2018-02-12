# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools eutils gnome2-utils python-r1 systemd multilib bash-completion-r1

DESCRIPTION="A firewall daemon with D-BUS interface providing a dynamic firewall"
HOMEPAGE="http://www.firewalld.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!!net-firewall/gshield
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/python-slip-0.2.7[dbus,${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-firewall/ebtables
	net-firewall/iptables[ipv6]
	net-firewall/ipset
	|| ( >=sys-apps/openrc-0.11.5 sys-apps/systemd )
	gui? (
		x11-libs/gtk+:3
		dev-python/PyQt4[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	>=dev-util/intltool-0.35
	sys-devel/gettext"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	python_setup

	econf \
		--enable-systemd \
		--with-iptables="${EPREFIX}/sbin/iptables" \
		--with-ip6tables="${EPREFIX}/sbin/ip6tables" \
		--with-iptables_restore="${EPREFIX}/sbin/iptables-restore" \
		--with-ip6tables_restore="${EPREFIX}/sbin/ip6tables-restore" \
		--with-ebtables="${EPREFIX}/sbin/ebtables" \
		--with-ebtables_restore="${EPREFIX}/sbin/ebtables-restore" \
		--with-systemd-unitdir="$(systemd_get_systemunitdir)" \
		--with-bashcompletiondir="$(get_bashcompdir)"
}

src_install() {
	# manually split up the installation to avoid "file already exists" errors
	emake -C config DESTDIR="${D}" install
	emake -C po DESTDIR="${D}" install
	emake -C shell-completion DESTDIR="${D}" install
	emake -C doc DESTDIR="${D}" install

	install_python() {
		emake -C src DESTDIR="${D}" pythondir="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl install_python

	python_replicate_script "${D}"/usr/bin/firewall-{offline-cmd,cmd,applet,config}
	python_replicate_script "${D}/usr/sbin/firewalld"

	# Get rid of junk
	rm -rf "${D}/etc/rc.d/"
	rm -rf "${D}/etc/sysconfig/"

	# For non-gui installs we need to remove GUI bits
	if ! use gui; then
		rm -rf "${D}/etc/xdg/autostart"
		rm -f "${D}/usr/bin/firewall-applet"
		rm -f "${D}/usr/bin/firewall-config"
		rm -rf "${D}/usr/share/applications"
		rm -rf "${D}/usr/share/icons"
	fi

	newinitd "${FILESDIR}"/firewalld.init firewalld
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
