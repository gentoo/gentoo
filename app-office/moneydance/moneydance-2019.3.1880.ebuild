# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eapi7-ver java-pkg-2 xdg-utils

MY_PN="Moneydance"
MY_PV="$(ver_cut 1-2)_$(ver_cut 3)"

DESCRIPTION="A cross-platform personal finance application"
HOMEPAGE="https://moneydance.com/"
SRC_URI="https://infinitekind.com/stabledl/${MY_PV}/${MY_PN}_linux_amd64.tar.gz -> ${P}-amd64.tar.gz"

LICENSE="Apache-1.0 Apache-2.0 BSD CPAL-1.0 CPL-1.0 CSL-2.0 LGPL-2 MIT TIK"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="|| (
		>=dev-java/openjdk-bin-11.0
		>=dev-java/openjdk-11.0
	)
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

RESTRICT="bindist fetch mirror"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://infinitekind.com/stabledl/${MY_PV}/${MY_PN}_linux_amd64.tar.gz"
	elog "and place it in your DISTDIR directory."
	elog ""
	elog "Please keep in mind, that you have to rename the download to ${P}-amd64.tar.gz."
}

src_compile() {
	:;
}

src_install() {
	java-pkg_dojar lib/*.jar

	newbin "${FILESDIR}/moneydance-bin" moneydance

	local iconsizes="32 128 512"
	for iconsize in ${iconsizes}; do
		newicon -s ${iconsize} resources/moneydance_icon${iconsize}.png moneydance.png
	done

	make_desktop_entry "moneydance" "Moneydance" moneydance Office
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
