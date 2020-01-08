# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils xdg-utils

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
K_LANGS="
	ar bg cs da de el en es fr it lt nl no pl pt_BR pt ro ru sv tr uk
"
for K_LANG in ${K_LANGS}; do
	IUSE+=" l10n_${K_LANG/_/-}"
done
DOCS=( ChangeLog README )

src_prepare() {
	default

	count() { echo ${#}; }
	local lang_count=$(count ${K_LANGS})
	local locale_count=$(count translations/${PN}_*.ts)
	[[ ${lang_count} = ${locale_count} ]] \
		|| die "Number of LANGS does not match number of locales"
	unset count

	local lang
	for lang in ${K_LANGS}; do
		if ! use l10n_${lang/_/-}; then
			rm translations/${PN}_${lang}.* || die
		fi
	done
}

src_configure() {
	eqmake5 kapow.pro PREFIX=/usr
}

src_install() {
	export INSTALL_ROOT="${D}"
	default
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
