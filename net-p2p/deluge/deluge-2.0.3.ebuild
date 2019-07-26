# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 eutils systemd user

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.deluge-torrent.org/deluge"
	SRC_URI=""
else
	SRC_URI="https://ftp.osuosl.org/pub/deluge/source/2.0/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="console geoip gtk libnotify sound webinterface"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	sound? ( gtk )
	libnotify? ( gtk )
"

DEPEND="net-libs/libtorrent-rasterbar[python,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	|| ( dev-python/slimit[${PYTHON_USEDEP}]
		dev-lang/closure-compiler-bin )
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-util/intltool"
RDEPEND="net-libs/libtorrent-rasterbar[python,${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/rencode[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.1[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	geoip? ( dev-python/geoip-python[${PYTHON_USEDEP}] )
	gtk? (
		dev-libs/libappindicator:3[introspection]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		gnome-base/librsvg
		libnotify? ( x11-libs/libnotify[introspection] )
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
	)
	webinterface? ( dev-python/mako[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local args=(
		-e "/Compiling po file/a \\\ \\ \\ \\ \\ \\ \\ \\ upto_date = False"
	)
	sed -i "${args[@]}" -- 'setup.py' || die
	args=(
		-e "s|'new_release_check': True|'new_release_check': False|"
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
	python_export PYTHON_SITEDIR
	if ! use console ; then
		rm -rf "${D%/}${PYTHON_SITEDIR}/deluge/ui/console/" || die
		rm -f "${D%/}/usr/bin/deluge-console" || die
		rm -f "${D%/}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gtk ; then
		rm -rf "${D%/}${PYTHON_SITEDIR}/deluge/ui/gtk3/" || die
		rm -rf "${D%/}/usr/share/icons/" || die
		rm -f "${D%/}/usr/bin/deluge-gtk" || die
		rm -f "${D%/}/usr/share/man/man1/deluge-gtk.1" || die
		rm -f "${D%/}/usr/share/applications/deluge.desktop" || die
	fi
	if use webinterface; then
		newinitd "${FILESDIR}/deluge-web.init" deluge-web
		newconfd "${FILESDIR}/deluge-web.conf" deluge-web
		systemd_newunit "${FILESDIR}/deluge-web.service-3" deluge-web.service
		systemd_install_serviced "${FILESDIR}/deluge-web.service.conf"
	else
		rm -rf "${D%/}${PYTHON_SITEDIR}/deluge/ui/web/" || die
		rm -f "${D%/}/usr/bin/deluge-web" || die
		rm -f "${D%/}/usr/share/man/man1/deluge-web.1" || die
	fi
	newinitd "${FILESDIR}"/deluged.init-2 deluged
	newconfd "${FILESDIR}"/deluged.conf-2 deluged
	systemd_newunit "${FILESDIR}"/deluged.service-3 deluged.service
	systemd_install_serviced "${FILESDIR}"/deluged.service.conf
}

pkg_postinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
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
