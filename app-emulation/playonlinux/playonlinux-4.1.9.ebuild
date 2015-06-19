# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/playonlinux/playonlinux-4.1.9.ebuild,v 1.1 2013/02/14 07:11:40 xmw Exp $

EAPI="4"
PYTHON_DEPEND="2"

inherit eutils python games gnome2-utils

MY_PN="PlayOnLinux"

DESCRIPTION="Set of scripts to easily install and use Windows games and software"
HOMEPAGE="http://playonlinux.com/"
SRC_URI="http://www.playonlinux.com/script_files/${MY_PN}/${PV}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="winbind"

DEPEND=""
RDEPEND="app-emulation/wine
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	app-crypt/gnupg
	dev-python/wxpython:2.8
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	net-misc/wget
	x11-apps/mesa-progs
	x11-terms/xterm
	media-gfx/icoutils
	|| ( net-analyzer/netcat net-analyzer/netcat6 )
	winbind? ( net-fs/samba[winbind] ) "

S=${WORKDIR}/${PN}

# TODO:
# Having a real install script and let playonlinux use standard filesystem
# 	architecture to prevent having everything installed into GAMES_DATADIR
# It will let using LANGUAGES easily
# How to deal with Microsoft Fonts installation asked every time ?
# How to deal with wine version installed ? (have a better mgmt of system one)
# Look at debian pkg: http://packages.debian.org/sid/playonlinux

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	games_pkg_setup
}

src_prepare() {
	sed -e 's/PYTHON="python"/PYTHON="python2"/' -i playonlinux || die
	python_convert_shebangs -r 2 .

	# remove playonmac
	rm etc/{playonmac.icns,terminal.applescript} || die

	# remove desktop integration
	rm etc/{PlayOnLinux.desktop,PlayOnLinux.directory,playonlinux-Programmes.menu} || die
}

src_install() {
	# all things without exec permissions
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r resources lang lib etc plugins

	# bash/ install
	exeinto "${GAMES_DATADIR}/${PN}/bash"
	doexe bash/*
	exeinto "${GAMES_DATADIR}/${PN}/bash/expert"
	doexe bash/expert/*

	# python/ install
	exeinto "${GAMES_DATADIR}/${PN}/python"
	doexe python/*
	# sub dir without exec permissions
	insinto "${GAMES_DATADIR}/${PN}/python"
	doins -r python/lib

	# main executable files
	exeinto "${GAMES_DATADIR}/${PN}"
	doexe ${PN}{,-pkg,-bash,-shell,-url_handler}

	# icons
	doicon -s 128 etc/${PN}.png
	for size in 16 22 32; do
		newicon -s $size etc/${PN}$size.png ${PN}.png
	done

	dodoc CHANGELOG

	games_make_wrapper ${PN} "./${PN}" "${GAMES_DATADIR}/${PN}"
	make_desktop_entry ${PN} ${MY_PN} ${PN} Game

	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	python_mod_optimize "${GAMES_DATADIR}/${PN}"
	gnome2_icon_cache_update
}

pkg_prerm() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Installed softwares and games with playonlinux have not been removed."
		elog "To remove them, you can re-install playonlinux and remove them using it"
		elog "or do it manually by removing .PlayOnLinux/ in your home directory."
	fi
}

pkg_postrm() {
	python_mod_cleanup "${GAMES_DATADIR}/${PN}"
	gnome2_icon_cache_update
}
