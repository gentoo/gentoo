# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eapi7-ver gnome2-utils java-pkg-2

MY_PN="Moneydance"
MY_PV="$(ver_cut 1)"

DESCRIPTION="A cross-platform personal finance application"
HOMEPAGE="https://moneydance.com/"
SRC_URI="
	amd64? ( https://infinitekind.com/stabledl/${MY_PV}/${MY_PN}_linux_amd64.tar.gz -> ${P}-amd64.tar.gz )
	x86? ( https://infinitekind.com/stabledl/${MY_PV}/${MY_PN}_linux_x86.tar.gz -> ${P}-x86.tar.gz )
"

LICENSE="Apache-1.0 Apache-2.0 BSD CPAL-1.0 CPL-1.0 CSL-2.0 LGPL-2 MIT TIK"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

S="${WORKDIR}/${MY_PN}"

RESTRICT="bindist fetch mirror"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://infinitekind.com/stabledl/${MY_PV}/${MY_PN}_linux_$(usex amd64 amd64 x86).tar.gz -> ${P}-$(usex amd64 amd64 x86).tar.gz"
	elog "and place it in your DISTDIR directory."
}

src_prepare() {
	default

	# Modify .desktop file, to fix QA errors
	sed -e 's/Application;//g' -e 's/.png//g' -i resources/moneydance.desktop || die
}

src_compile() {
	:;
}

src_install() {
	java-pkg_dojar jars/*.jar
	java-pkg_dolauncher moneydance --main "Moneydance" --java_args "-client -Dawt.useSystemAAFontSettings=gasp -Dawt.useSystemAAFontSettings=on -Xmx1024m"

	doicon resources/*.png
	domenu resources/moneydance.desktop
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
