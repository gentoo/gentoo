# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 xdg-utils

MY_PN="Moneydance"
MY_PV="$(ver_cut 1)_$(ver_cut 2)"

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

RESTRICT="bindist mirror"

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
