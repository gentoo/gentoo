# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils python-single-r1 games

MY_PN="PlayOnLinux"

DESCRIPTION="Set of scripts to easily install and use Windows games and software"
HOMEPAGE="http://playonlinux.com/"
SRC_URI="http://www.playonlinux.com/script_files/${MY_PN}/${PV}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="winbind"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	app-emulation/wine
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	app-crypt/gnupg
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	net-misc/wget
	x11-apps/mesa-progs
	x11-terms/xterm
	media-gfx/icoutils
	|| ( net-analyzer/netcat net-analyzer/netcat6 )
	virtual/imagemagick-tools
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
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.2.4-pol-bash.patch"
	epatch "${FILESDIR}/${PN}-4.2.4-binary-plugin.patch"
	epatch "${FILESDIR}/${PN}-4.2.6-stop-update-warning.patch"

	python_fix_shebang .

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
	find "${S}/bash" -type f -exec doexe '{}' +
	exeinto "${GAMES_DATADIR}/${PN}/bash/expert"
	find "${S}/bash/expert" -type f -exec doexe '{}' +

	# python/ install
	python_moduleinto "${GAMES_DATADIR}/${PN}"
	python_domodule python

	# main executable files
	exeinto "${GAMES_DATADIR}/${PN}"
	doexe ${PN}{,-pkg,-bash,-shell,-url_handler}

	# icons
	doicon -s 128 etc/${PN}.png
	for size in 16 22 32; do
		newicon -s $size etc/${PN}$size.png ${PN}.png
	done

	doman "${FILESDIR}"/playonlinux{,-pkg}.1
	dodoc CHANGELOG.md

	games_make_wrapper ${PN} "./${PN}" "${GAMES_DATADIR}/${PN}"
	games_make_wrapper ${PN}-pkg "./${PN}-pkg" "${GAMES_DATADIR}/${PN}"
	make_desktop_entry ${PN} ${MY_PN} ${PN} Game

	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
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
	gnome2_icon_cache_update
}
