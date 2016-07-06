# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
KMNOMODULE="true"
inherit kde4-meta prefix

DESCRIPTION="Startkde script, which starts a complete KDE session, and associated scripts"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="+wallpapers"

# The KDE apps called from the startkde script.
# These provide the most minimal KDE desktop.
RDEPEND="
	$(add_kdebase_dep kcminit)
	$(add_kdeapps_dep kdebase-runtime-meta)
	$(add_kdeapps_dep kfmclient)
	$(add_kdeapps_dep knotify)
	$(add_kdeapps_dep kreadconfig)
	$(add_kdebase_dep krunner)
	$(add_kdebase_dep ksmserver)
	$(add_kdebase_dep ksplash)
	$(add_kdebase_dep kstartupconfig)
	$(add_kdebase_dep kwin)
	$(add_kdeapps_dep phonon-kde)
	$(add_kdeapps_dep plasma-apps)
	$(add_kdebase_dep plasma-workspace)
	$(add_kdebase_dep systemsettings)
	x11-apps/mkfontdir
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrandr
	x11-apps/xrdb
	x11-apps/xsetroot
	x11-apps/xset
	wallpapers? ( $(add_kdeapps_dep kde-wallpapers '' 15.08.3) )
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
