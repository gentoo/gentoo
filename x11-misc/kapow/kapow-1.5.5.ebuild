# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils qmake-utils

DESCRIPTION="A punch clock program designed to easily keep track of your hours"
HOMEPAGE="https://gottcode.org/kapow/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
"
K_LINGUAS="
	ar bg cs da de el en es fr it lt nl no pl pt_BR ro ru sv tr uk
"
for K_LINGUA in ${K_LINGUAS}; do
	IUSE+=" linguas_${K_LINGUA}"
done
DOCS=( ChangeLog README )

src_prepare() {
	default

	count() { echo ${#}; }
	local lingua_count=$(count ${K_LINGUAS})
	local locale_count=$(count translations/${PN}_*.ts)
	[[ ${lingua_count} = ${locale_count} ]] \
		|| die "Number of LINGUAS does not match number of locales"
	unset count

	local lingua
	if [[ -n "${LINGUAS}" ]]; then
		for lingua in ${K_LINGUAS}; do
			if ! use linguas_${lingua}; then
				rm translations/${PN}_${lingua}.* || die
			fi
		done
	fi
}

src_configure() {
	eqmake5 kapow.pro PREFIX=/usr
}

src_install() {
	export INSTALL_ROOT="${D}"
	default
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
