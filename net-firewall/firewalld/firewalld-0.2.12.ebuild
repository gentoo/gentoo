# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/firewalld/firewalld-0.2.12.ebuild,v 1.2 2015/04/08 18:16:34 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
#BACKPORTS=190680ba

inherit autotools eutils gnome2-utils python-r1 systemd multilib

DESCRIPTION="A firewall daemon with D-BUS interface providing a dynamic firewall"
HOMEPAGE="http://fedorahosted.org/firewalld"
SRC_URI="https://fedorahosted.org/released/firewalld/${P}.tar.bz2
	${BACKPORTS:+http://dev.gentoo.org/~cardoe/distfiles/${P}-${BACKPORTS}.tar.xz}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python
	dev-python/decorator
	>=dev-python/python-slip-0.2.7[dbus]
	dev-python/pygobject:3
	net-firewall/ebtables
	net-firewall/iptables[ipv6]
	|| ( >=sys-apps/openrc-0.11.5 sys-apps/systemd )
	gui? (
		dev-python/pygtk:2
		>=x11-libs/gtk+-2.6:2
		x11-libs/gtk+:3
	)"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	>=dev-util/intltool-0.35
	sys-devel/gettext"

src_prepare() {
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" \
			epatch

	epatch_user
	eautoreconf
}

src_configure() {
	python_export_best

	econf \
		--enable-systemd
		"$(systemd_with_unitdir 'systemd-unitdir')"
}

src_install() {
	python_foreach_impl \
		emake DESTDIR="${ED}" pythondir="$(python_get_sitedir)" install

	# Get rid of junk
	rm -f "${ED}/etc/rc.d/init.d/firewalld"
	rm -f "${ED}/etc/sysconfig/firewalld"
	rm -rf "${ED}/etc/rc.d/"
	rm -rf "${ED}/etc/sysconfig/"

	# For non-gui installs we need to remove GUI bits
	if ! use gui; then
		rm -f "${ED}/usr/bin/firewall-applet"
		rm -f "${ED}/usr/bin/firewall-config"
		rm -rf "${ED}/usr/share/icons"
		rm -rf "${ED}/usr/share/applications"
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
