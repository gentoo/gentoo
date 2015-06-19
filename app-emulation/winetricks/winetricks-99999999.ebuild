# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/winetricks/winetricks-99999999.ebuild,v 1.16 2015/06/04 18:59:05 kensington Exp $

EAPI=5

inherit gnome2-utils eutils

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://github.com/Winetricks/${PN}.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/Winetricks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
wtg=winetricks-gentoo-2012.11.24
SRC_URI="${SRC_URI}
	gtk? ( http://dev.gentoo.org/~tetromino/distfiles/wine/${wtg}.tar.bz2 )
	kde? ( http://dev.gentoo.org/~tetromino/distfiles/wine/${wtg}.tar.bz2 )"

DESCRIPTION="Easy way to install DLLs needed to work around problems in Wine"
HOMEPAGE="http://winetricks.org http://wiki.winehq.org/winetricks"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gtk kde rar"

DEPEND=""
RDEPEND="app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	app-emulation/wine
	net-misc/wget
	x11-misc/xdg-utils
	gtk? ( gnome-extra/zenity )
	kde? ( kde-apps/kdialog )
	rar? ( app-arch/unrar )"

# Uses non-standard "Wine" category, which is provided by app-emulation/wine; #451552
QA_DESKTOP_FILE="usr/share/applications/winetricks.desktop"

# Tests require network access and run wine, which is unreliable from a portage environment
RESTRICT="test"

src_unpack() {
	if [[ ${PV} == "99999999" ]] ; then
		git-r3_src_unpack
		if use gtk || use kde; then
			unpack ${wtg}.tar.bz2
		fi
	else
		default
	fi
}

src_install() {
	default
	if use gtk || use kde; then
		cd "${WORKDIR}/${wtg}" || die
		domenu winetricks.desktop
		insinto /usr/share/icons/hicolor/scalable/apps
		doins wine-winetricks.svg
	fi
}

pkg_preinst() {
	if use gtk || use kde; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use gtk || use kde; then
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if use gtk || use kde; then
		gnome2_icon_cache_update
	fi
}
