# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils distutils-r1 vcs-snapshot

DESCRIPTION="Integrated version control support for your desktop"
HOMEPAGE="http://rabbitvcs.org"
SRC_URI="https://github.com/rabbitvcs/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caja cli diff gedit git nautilus spell thunar"

RDEPEND="dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pysvn[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	caja? ( dev-python/python-caja[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/gnome-vfs-python[${PYTHON_USEDEP}] )
	diff? ( dev-util/meld )
	gedit? ( app-editors/gedit[${PYTHON_USEDEP}] )
	git? ( dev-python/dulwich[${PYTHON_USEDEP}] )
	nautilus? ( >=dev-python/nautilus-python-0.7.0[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/gnome-vfs-python[${PYTHON_USEDEP}] )
	spell? ( dev-python/gtkspell-python[${PYTHON_USEDEP}] )
	thunar? ( dev-python/thunarx-python[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}] )"

python_prepare_all() {
#	python_convert_shebangs -r 2 .

#	distutils_src_prepare

	# we should not do gtk-update-icon-cache from setup script
	# we prefer portage for that
	sed -e 's/"install"/"fakeinstall"/' -i "${S}/setup.py" || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	if use caja ; then
		python_moduleinto /usr/share/caja-python/extensions
		python_domodule clients/caja/RabbitVCS.py
	fi
	if use cli ; then
		python_doscript clients/cli/rabbitvcs
	fi
	if use gedit ; then
		python_moduleinto /usr/$(get_libdir)/gedit-2/plugins
		python_domodule clients/gedit/rabbitvcs-plugin.py
		insinto /usr/$(get_libdir)/gedit-2/plugins
		doins clients/gedit/rabbitvcs-gedit2.gedit-plugin
		python_moduleinto /usr/$(get_libdir)/gedit-2/plugins
		python_domodule clients/gedit/rabbitvcs-plugin.py
		insinto /usr/$(get_libdir)/gedit/plugins
		doins clients/gedit/rabbitvcs-gedit3.plugin
	fi
	if use nautilus ; then
		python_moduleinto /usr/$(get_libdir)/nautilus/extensions-2.0/python
		python_domodule clients/nautilus/RabbitVCS.py
		python_moduleinto /usr/share/nautilus-python/extensions
		python_domodule clients/nautilus-3.0/RabbitVCS.py
	fi
	if use thunar ; then
		python_moduleinto "/usr/$(get_libdir)/thunarx-2/python"
		python_domodule clients/thunar/RabbitVCS.py
		python_moduleinto "/usr/$(get_libdir)/thunarx-1/python"
		python_domodule clients/thunar/RabbitVCS.py
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
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
	gnome2_icon_cache_update
}
