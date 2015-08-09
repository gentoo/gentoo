# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils fdo-mime gnome2-utils distutils-r1 versionator

MY_PV="$(get_version_component_range 1-2)"
DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="http://gtg.fritalk.com/"
SRC_URI="http://launchpad.net/${PN}/${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/liblarch[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# Plugins are voluntarily left automagic as application has a nice way
	# to suggest missing dependencies. We only remove the ones that cannot
	# work on gentoo.
	# Backends should be enabled via USE flag when pulling extra deps

	# tweepy: missing python-r1 support
	# geoloc: uses removed from tree bindings
	sed -e "/GTG.backends.tweepy/d" \
		-e "/GTG.plugins.geolocalized_tasks',/d" \
		-e "/geolocalized-tasks.gtg-plugin/d" \
		-i setup.py || die

	# launchpad: missing dependency
	# mantis: missing python-r1 support
	# evolution: missing python-r1 support
	rm GTG/backends/backend_launchpad.py \
		GTG/backends/backend_mantis.py \
		GTG/backends/backend_evolution.py \
		GTG/backends/backend_twitter.py \
		|| die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
