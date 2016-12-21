# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
KMNOMODULE="true"
inherit kde4-meta prefix

DESCRIPTION="Script which starts a complete Plasma session, and associated scripts"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="crash-reporter +handbook minimal +wallpapers"

# The KDE apps called from the startkde script.
# These provide the most minimal KDE desktop.
RDEPEND="
	$(add_kdeapps_dep attica)
	$(add_kdeapps_dep kcmshell)
	$(add_kdeapps_dep kcontrol)
	$(add_kdeapps_dep kdebase-data)
	$(add_kdeapps_dep kdebase-desktoptheme)
	$(add_kdeapps_dep kdebase-kioslaves)
	$(add_kdeapps_dep kdebase-menu)
	$(add_kdeapps_dep kdebase-menu-icons)
	$(add_kdeapps_dep kdebugdialog)
	$(add_kdeapps_dep kdesu)
	$(add_kdeapps_dep kdontchangethehostname)
	$(add_kdeapps_dep keditfiletype)
	$(add_kdeapps_dep kfile)
	$(add_kdeapps_dep kfmclient)
	$(add_kdeapps_dep kglobalaccel)
	$(add_kdeapps_dep kiconfinder)
	$(add_kdeapps_dep kimgio)
	$(add_kdeapps_dep kioclient)
	$(add_kdeapps_dep kmimetypefinder)
	$(add_kdeapps_dep knetattach)
	$(add_kdeapps_dep knewstuff)
	$(add_kdeapps_dep knotify)
	$(add_kdeapps_dep kpasswdserver)
	$(add_kdeapps_dep kquitapp)
	$(add_kdeapps_dep kreadconfig)
	$(add_kdeapps_dep kstart)
	$(add_kdeapps_dep ktimezoned)
	$(add_kdeapps_dep ktraderclient)
	$(add_kdeapps_dep kuiserver)
	$(add_kdeapps_dep kurifilter-plugins)
	$(add_kdeapps_dep kwalletd)
	$(add_kdeapps_dep kwalletmanager)
	$(add_kdeapps_dep phonon-kde)
	$(add_kdeapps_dep plasma-apps)
	$(add_kdeapps_dep plasma-runtime)
	$(add_kdeapps_dep renamedlg-plugins)
	$(add_kdeapps_dep solid-runtime)
	kde-plasma/kcminit:4
	kde-plasma/krunner:4
	kde-plasma/ksmserver:4
	kde-plasma/ksplash:4
	kde-plasma/kstartupconfig:4
	kde-plasma/kwin:4
	kde-plasma/plasma-workspace:4
	kde-plasma/systemsettings:4
	x11-apps/mkfontdir
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrandr
	x11-apps/xrdb
	x11-apps/xsetroot
	x11-apps/xset
	crash-reporter? ( $(add_kdeapps_dep drkonqi ) )
	handbook? ( kde-apps/khelpcenter:* )
	!minimal? (
		$(add_kdeapps_dep kdepasswd)
		kde-plasma/freespacenotifier:4
		kde-plasma/kcheckpass:4
		kde-plasma/kdebase-cursors:4
		kde-plasma/kephal:4
		kde-plasma/khotkeys:4
		kde-plasma/kinfocenter:4
		kde-plasma/klipper:4
		kde-plasma/kmenuedit:4
		kde-plasma/kstyles:4
		kde-plasma/ksysguard:4
		kde-plasma/ksystraycmd:4
		kde-plasma/kwrited:4
		kde-plasma/libkworkspace:4
		kde-plasma/liboxygenstyle:4
		kde-plasma/libplasmaclock:4
		kde-plasma/libplasmagenericshell:4
		kde-plasma/libtaskmanager:4
		kde-plasma/powerdevil:4
		kde-plasma/qguiplatformplugin_kde:4
		kde-plasma/solid-actions-kcm:4
	)
	wallpapers? ( kde-plasma/plasma-workspace-wallpapers:5 )
"

KMEXTRACTONLY="
	ConfigureChecks.cmake
	kdm/
	startkde.cmake
"

PATCHES=(
	"${FILESDIR}/gentoo-startkde4-4.patch"
	"${FILESDIR}/${PN}-kscreen.patch"
	"${FILESDIR}/${PN}-kwalletd-pam.patch"
)

src_prepare() {
	kde4-meta_src_prepare

	cp "${FILESDIR}/KDE-4" "${T}"

	# fix ${EPREFIX}
	eprefixify startkde.cmake "${T}/KDE-4"
}

src_install() {
	kde4-meta_src_install

	# startup and shutdown scripts
	insinto /etc/kde/startup
	doins "${FILESDIR}/agent-startup.sh"

	insinto /etc/kde/shutdown
	doins "${FILESDIR}/agent-shutdown.sh"

	# x11 session script
	exeinto /etc/X11/Sessions
	doexe "${T}/KDE-4"

	# freedesktop compliant session script
	sed -e "s:\${BIN_INSTALL_DIR}:${EPREFIX}/usr/bin:g" \
		"${S}/kdm/kfrontend/sessions/kde-plasma.desktop.cmake" > "${T}/KDE-4.desktop"
	insinto /usr/share/xsessions
	doins "${T}/KDE-4.desktop"
}

pkg_postinst () {
	kde4-meta_pkg_postinst

	echo
	elog "To enable gpg-agent and/or ssh-agent in KDE sessions,"
	elog "edit ${EPREFIX}/etc/kde/startup/agent-startup.sh and"
	elog "${EPREFIX}/etc/kde/shutdown/agent-shutdown.sh"
	echo
	elog "The name of the session script has changed."
	elog "If you currently have XSESSION=\"kde-$(get_kde_version)\" in your"
	elog "configuration files, you will need to change it to"
	elog "XSESSION=\"KDE-4\""
}
