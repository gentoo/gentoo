# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES=(
ar ca cs da de el en-GB en-US es-AR es-ES et eu fi fr he hu id it ja ko
lt lv nb nl pl pt-BR pt-PT ro ru sk sv tr uz vi zh-CN
)

CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils gnome2-utils

DESCRIPTION="Fast and usable calculator for power users"
HOMEPAGE="http://speedcrunch.org/"
SRC_URI="https://bitbucket.org/heldercorreia/${PN}/get/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc ${PLOCALES[@]/#/l10n_}"

DEPEND="
dev-qt/qtcore:5
dev-qt/qthelp:5
dev-qt/qtsql:5
dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/heldercorreia-speedcrunch-ea93b21f9498/src"

src_prepare() {
	local i
	for i in "${PLOCALES[@]}" ; do
		use l10n_${i} || \
			sed "\|locale/${i/-/_}|d" -i resources/speedcrunch.qrc || die
	done

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	cd .. || die
	doicon -s scalable gfx/speedcrunch.svg

	if use doc ; then
		local i doclangs
		for i in de en_US es_ES fr ; do
			use l10n_${i/_/-} && doclangs+=" ${i}"
		done

		if [[ -z ${doclangs} ]] ; then
			ewarn "Couldn't find a matching translation for documentation. Defaulting to: en_US"
			doclangs="en_US"
		fi

		for i in ${doclangs} ; do
			dodoc -r doc/build_html_embedded/${i}*/
		done
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
