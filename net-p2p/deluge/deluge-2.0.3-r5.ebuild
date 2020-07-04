# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 systemd

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.deluge-torrent.org/${PN}"
else
	SRC_URI="http://download.deluge-torrent.org/source/2.0/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="console geoip gtk libnotify sound webinterface"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	libnotify? ( gtk )
	sound? ( gtk )
"

DEPEND="
	$(python_gen_cond_dep '
		net-libs/libtorrent-rasterbar[python,${PYTHON_MULTI_USEDEP}]
		dev-python/wheel[${PYTHON_MULTI_USEDEP}]
	')
	dev-util/intltool
	acct-group/deluge
	acct-user/deluge"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_MULTI_USEDEP}]
		dev-python/distro[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/pyopenssl[${PYTHON_MULTI_USEDEP}]
		dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
		dev-python/rencode[${PYTHON_MULTI_USEDEP}]
		dev-python/setproctitle[${PYTHON_MULTI_USEDEP}]
		dev-python/six[${PYTHON_MULTI_USEDEP}]
		>=dev-python/twisted-17.1.0[crypt,${PYTHON_MULTI_USEDEP}]
		>=dev-python/zope-interface-4.4.2[${PYTHON_MULTI_USEDEP}]
		geoip? ( dev-python/geoip-python[${PYTHON_MULTI_USEDEP}] )
		gtk? (
			sound? ( dev-python/pygame[${PYTHON_MULTI_USEDEP}] )
			dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
			gnome-base/librsvg
			libnotify? ( x11-libs/libnotify )
		)
		net-libs/libtorrent-rasterbar[python,${PYTHON_MULTI_USEDEP}]
		dev-python/mako[${PYTHON_MULTI_USEDEP}]
	')"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.3-setup.py.patch"
	"${FILESDIR}/${PN}-2.0.3-UI-status.patch"
)

python_prepare_all() {
	local args=(
		-e "/Compiling po file/a \\\tuptoDate = False"
	)
	sed -i "${args[@]}" -- 'setup.py' || die
	args=(
		-e 's|"new_release_check": True|"new_release_check": False|'
		-e 's|"check_new_releases": True|"check_new_releases": False|'
		-e 's|"show_new_releases": True|"show_new_releases": False|'
	)
	sed -i "${args[@]}" -- 'deluge/core/preferencesmanager.py' || die

	distutils-r1_python_prepare_all
}

esetup.py() {
	# bug 531370: deluge has its own plugin system. No need to relocate its egg info files.
	# Override this call from the distutils-r1 eclass.
	# This does not respect the distutils-r1 API. DONOT copy this example.
	set -- "${PYTHON}" setup.py "$@"
	echo "$@"
	"$@" || die
}

python_install_all() {
	distutils-r1_python_install_all
	if ! use console ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/console/" || die
		rm "${D}/usr/bin/deluge-console" || die
		rm "${D}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gtk ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/gtk3/" || die
		rm -r "${D}/usr/share/icons/" || die
		rm "${D}/usr/bin/deluge-gtk" || die
		rm "${D}/usr/share/man/man1/deluge-gtk.1" || die
		rm "${D}/usr/share/applications/deluge.desktop" || die
	fi
	if use webinterface; then
		newinitd "${FILESDIR}/deluge-web.init-2" deluge-web
		newconfd "${FILESDIR}/deluge-web.conf" deluge-web
		systemd_newunit "${FILESDIR}/deluge-web.service-3" deluge-web.service
		systemd_install_serviced "${FILESDIR}/deluge-web.service.conf"
	else
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/web/" || die
		rm "${D}/usr/bin/deluge-web" || die
		rm "${D}/usr/share/man/man1/deluge-web.1" || die
	fi
	newinitd "${FILESDIR}"/deluged.init-2 deluged
	newconfd "${FILESDIR}"/deluged.conf-2 deluged
	systemd_newunit "${FILESDIR}"/deluged.service-2 deluged.service
	systemd_install_serviced "${FILESDIR}"/deluged.service.conf

	python_optimize
}

pkg_postinst() {
	elog
	elog "If, after upgrading, deluge doesn't work, please remove the"
	elog "'~/.config/deluge' directory and try again, but make a backup"
	elog "first!"
	elog
	elog "To start the daemon either run 'deluged' as user"
	elog "or modify /etc/conf.d/deluged and run"
	elog "/etc/init.d/deluged start as root"
	elog "You can still use deluge the old way"
	elog
	elog "Systemd unit files for deluged and deluge-web no longer source"
	elog "/etc/conf.d/deluge* files. Environment variable customization now"
	elog "happens in /etc/systemd/system/deluged.service.d/00gentoo.conf"
	elog "and /etc/systemd/system/deluge-web.service.d/00gentoo.conf"
	elog
	elog "For more information look at https://dev.deluge-torrent.org/wiki/Faq"
	elog
}
