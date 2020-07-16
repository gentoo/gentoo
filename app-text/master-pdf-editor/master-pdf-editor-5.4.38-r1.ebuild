# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="A complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
SRC_URI="https://code-industry.net/public/${P}-qt5-all.amd64.tar.gz"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND=">=media-gfx/sane-backends-1.0"

QA_PREBUILT="/opt/${PN}/masterpdfeditor5
	/opt/${PN}/lib/*.so*
	/opt/${PN}/iconengines/*.so*
	/opt/${PN}/platformthemes/*.so*
	/opt/${PN}/printsupport/*.so*
	/opt/${PN}/platforms/*.so*
	/opt/${PN}/imageformats/*.so*
"

S="${WORKDIR}/${PN}-${PV%%.*}"

src_prepare() {
	sed -i 's/libpath=$(cd "$(dirname "$0")"; pwd)/libpath=$(cd "$(dirname $(readlink -f `which "$0"`))"; pwd)/' "${WORKDIR}"/*/masterpdfeditor5.sh || die
	sed -i 's/dirname=`dirname $0`/dirname=$libpath/' "${WORKDIR}"/*/masterpdfeditor5.sh || die

	eapply_user
}

src_install() {
	insinto /opt/${PN}
	doins -r fonts iconengines imageformats lang lib platforms platformthemes printsupport stamps templates masterpdfeditor5.png

	exeinto /opt/${PN}
	doexe masterpdfeditor5 masterpdfeditor5.sh
	dosym ../${PN}/masterpdfeditor5.sh /opt/bin/masterpdfeditor5

	make_desktop_entry "masterpdfeditor5 %f" \
		"Master PDF Editor ${PV}" /opt/${PN}/masterpdfeditor5.png \
		"Office;Graphics;Viewer" \
		"MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;\nTerminal=false"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
