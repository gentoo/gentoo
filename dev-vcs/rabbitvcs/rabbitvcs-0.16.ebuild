# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils gnome2-utils multilib distutils vcs-snapshot

DESCRIPTION="Integrated version control support for your desktop"
HOMEPAGE="http://rabbitvcs.org"
SRC_URI="http://github.com/rabbitvcs/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caja cli diff gedit git nautilus spell thunar"

RDEPEND="dev-python/configobj
	dev-python/pygobject:2
	dev-python/pygtk
	dev-python/pysvn
	dev-python/simplejson
	caja? ( dev-python/python-caja
		dev-python/dbus-python
		dev-python/gnome-vfs-python )
	diff? ( dev-util/meld )
	gedit? ( app-editors/gedit )
	git? ( dev-python/dulwich )
	nautilus? ( >=dev-python/nautilus-python-0.7.0
		dev-python/dbus-python
		dev-python/gnome-vfs-python )
	spell? ( dev-python/gtkspell-python )
	thunar? ( dev-python/thunarx-python
		dev-python/dbus-python )"

src_prepare() {
	python_convert_shebangs -r 2 .

	distutils_src_prepare

	# we should not do gtk-update-icon-cache from setup script
	# we prefer portage for that
	sed -e 's/"install"/"fakeinstall"/' -i "${S}/setup.py" || die
}

src_install() {
	distutils_src_install

	if use caja ; then
		insinto /usr/share/caja-python/extensions
		doins clients/caja/RabbitVCS.py
	fi
	if use cli ; then
		dobin clients/cli/${PN}
	fi
	if use gedit ; then
		insinto /usr/$(get_libdir)/gedit-2/plugins
		doins clients/gedit/${PN}-plugin.py
		doins clients/gedit/${PN}-gedit2.gedit-plugin
		insinto /usr/$(get_libdir)/gedit/plugins
		doins clients/gedit/${PN}-plugin.py
		doins clients/gedit/${PN}-gedit3.plugin
	fi
	if use nautilus ; then
		insinto /usr/$(get_libdir)/nautilus/extensions-2.0/python
		doins clients/nautilus/RabbitVCS.py
		insinto /usr/share/nautilus-python/extensions
		doins clients/nautilus-3.0/RabbitVCS.py
	fi
	if use thunar ; then
		insinto "/usr/$(get_libdir)/thunarx-2/python"
		doins clients/thunar/RabbitVCS.py
		insinto "/usr/$(get_libdir)/thunarx-1/python"
		doins clients/thunar/RabbitVCS.py
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update

	elog "You should restart file manager to changes take effect:"
	use caja && elog "\$ caja -q"
	use nautilus && elog "\$ nautilus -q"
	use thunar && elog "\$ thunar -q && thunar &"
	elog ""
	elog "Also you should really look at known issues page:"
	elog "http://wiki.rabbitvcs.org/wiki/support/known-issues"
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
