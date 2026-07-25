# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 greadme systemd xdg

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.deluge-torrent.org/${PN}"
else
	SRC_URI="http://download.deluge-torrent.org/source/$(ver_cut 1-2)/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="appindicator console gui libnotify sound webinterface"
REQUIRED_USE="
	appindicator? ( gui )
	libnotify? ( gui )
	sound? ( gui )
"

BDEPEND="
	dev-util/intltool
"

RDEPEND="
	acct-group/deluge
	acct-user/deluge
	net-libs/libtorrent-rasterbar:=[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		gui? (
			sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
			dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		)
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pkg-resources[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/rencode[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/twisted-17.1.0[ssl(-),${PYTHON_USEDEP}]
		>=dev-python/zope-interface-4.4.2[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
	')
	appindicator? ( dev-libs/libayatana-appindicator )
	gui? (
		gnome-base/librsvg:2
		libnotify? ( x11-libs/libnotify )
	)
"

EPYTEST_PLUGINS=( pytest-twisted )
distutils_enable_tests pytest

python_prepare_all() {
	local args=(
		-e 's|"new_release_check": True|"new_release_check": False|'
		-e 's|"check_new_releases": True|"check_new_releases": False|'
		-e 's|"show_new_releases": True|"show_new_releases": False|'
	)
	sed -i "${args[@]}" -- 'deluge/core/preferencesmanager.py' || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_IGNORE=(
		# Upstream CI/CD skips these and they seem to intentionally segfault to collect core dumps...
		deluge/plugins/Stats/deluge_stats/tests/test_stats.py
		# Skipped upstream
		deluge/tests/test_security.py
		# Broken
		deluge/tests/test_ui_entry.py
		deluge/tests/test_webserver.py
	)
	local EPYTEST_DESELECT=(
		# Skipped upstream
		'deluge/plugins/WebUi/deluge_webui/tests/test_plugin_webui.py::TestWebUIPlugin::test_enable_webui'
		'deluge/tests/test_torrent.py::TestTorrent::test_torrent_error_resume_data_unaltered'
		'deluge/tests/test_tracker_icons.py::TestTrackerIcons::test_get_seo_svg_with_sni'
		# never returns
		'deluge/tests/test_ui_entry.py::TestConsoleScriptEntryWithDaemon'
		# failing network(?)-related tests, even with sandbox disabled
		'deluge/tests/test_common.py::TestCommon::test_is_interface'
		# fails
		'deluge/tests/test_core.py::TestCore::test_pause_torrents'
		# fails because of network sandbox
		'deluge/tests/test_core.py::TestCore::test_test_listen_port'
		'deluge/tests/test_tracker_icons.py::TestTrackerIcons::test_get_deluge_png'
		'deluge/tests/test_tracker_icons.py::TestTrackerIcons::test_get_google_ico'
		'deluge/tests/test_tracker_icons.py::TestTrackerIcons::test_get_google_ico_hebrew'
		'deluge/tests/test_tracker_icons.py::TestTrackerIcons::test_get_google_ico_with_redirect'
		# segfaults with FEATURES="network-sandbox"
		'deluge/tests/test_core.py::TestCore::test_pause_torrent'
	)

	epytest -m "not (todo or gtkui)" -v
}

python_install_all() {
	distutils-r1_python_install_all
	if ! use console ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/console/" || die
		rm "${ED}/usr/bin/deluge-console" || die
		rm "${ED}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gui ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/gtk3/" || die
		rm -r "${ED}/usr/share/icons/" || die
		rm "${ED}/usr/bin/deluge-gtk" || die
		rm "${ED}/usr/share/man/man1/deluge-gtk.1" || die
	else
		mkdir -p "${ED}/usr/share/applications/" || die
		cp "${WORKDIR}/${P}/deluge/ui/data/share/applications/deluge.desktop" "${ED}/usr/share/applications/" || die
		mkdir -p "${ED}/usr/share/metainfo" || die
		cp "${WORKDIR}/${P}/deluge/ui/data/share/metainfo/deluge.metainfo.xml" "${ED}/usr/share/metainfo/" || die
	fi

	if use webinterface; then
		newinitd "${FILESDIR}/deluge-web.init-2" deluge-web
		newconfd "${FILESDIR}/deluge-web.conf" deluge-web
		systemd_newunit "${FILESDIR}/deluge-web.service-4" deluge-web.service
		systemd_install_serviced "${FILESDIR}/deluge-web.service.conf"
	else
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/web/" || die
		rm "${ED}/usr/bin/deluge-web" || die
		rm "${ED}/usr/share/man/man1/deluge-web.1" || die
	fi

	newinitd "${FILESDIR}"/deluged.init-2 deluged
	newconfd "${FILESDIR}"/deluged.conf-2 deluged
	systemd_newunit "${FILESDIR}"/deluged.service-2 deluged.service
	systemd_install_serviced "${FILESDIR}"/deluged.service.conf

	python_optimize

	greadme_stdin <<-EOF
	To start only the daemon either run 'deluged' as user or modify
	/etc/conf.d/deluged and run '/etc/init.d/deluged start' as root
	if you use OpenRC or 'systemctl start deluged.service' if you use systemd.

	Systemd unit files for deluged and deluge-web no longer source
	/etc/conf.d/deluge* files. Environment variable customization now happens in
	/etc/systemd/system/deluged.service.d/00gentoo.conf and
	/etc/systemd/system/deluge-web.service.d/00gentoo.conf

	For more information see https://deluge-torrent.org/faq/
EOF
}

pkg_preinst() {
	xdg_pkg_preinst
	greadme_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	greadme_pkg_postinst
}
