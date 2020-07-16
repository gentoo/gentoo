# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 xdg-utils

MY_PN="${PN^}"

DESCRIPTION="Java subtitle editor"
HOMEPAGE="https://www.jubler.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-source-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mplayer spell nls"

RDEPEND="
	mplayer? ( media-video/mplayer[libass] )
	spell? ( app-text/aspell )
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	local REMOVE_PLUGINS=() _plugin
	use mplayer || REMOVE_PLUGINS+=( mplayer )
	use spell || REMOVE_PLUGINS+=( aspell zemberek )
	for _plugin in "${REMOVE_PLUGINS[@]}"; do
		rm -rv "plugins/${_plugin}" || die
	done
}

src_compile() {
	local JUBLER_TARGETS=()
	use nls || JUBLER_TARGETS+=( core help )
	eant -f "${S}/build.xml" "${JUBLER_TARGETS[@]}"
}

src_install() {
	DESTDIR="${D}" eant linuxdesktopintegration
	rm -rv "${D}/usr/share/menu" || die

	doicon "resources/installers/linux/${PN}.png"
	domenu "resources/installers/linux/${PN}.desktop"

	java-pkg_dojar dist/Jubler.jar
	java-pkg_dolauncher "${PN}" --main Jubler

	if use nls; then
		insinto "/usr/share/${PN}/lib/i18n/"
		doins dist/i18n/*.jar
	fi

	insinto "/usr/share/${PN}/lib/themes"
	doins dist/themes/coretheme.jar
	insinto "/usr/share/${PN}/lib/lib"
	doins dist/lib/*.jar

	insinto "/usr/share/${PN}/help"
	doins resources/help/*

	doman "resources/installers/linux/${PN}.1"
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
