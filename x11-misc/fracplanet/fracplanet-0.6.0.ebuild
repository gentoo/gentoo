# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Fractal planet and terrain generator"
HOMEPAGE="https://github.com/chaseleif/fracplanet/"
SRC_URI="https://github.com/chaseleif/fracplanet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-libs/libxslt"
RDEPEND="
	dev-libs/boost:=
	dev-qt/qtbase:6[gui,opengl,-gles2-only,widgets]
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-musl.patch
)

HTML_DOCS=( fracplanet.{htm,css} )

src_configure() {
	eqmake6 fracplanet.pro
}

src_compile() {
	xsltproc -stringparam version ${PV} -html htm_to_qml.xsl fracplanet.htm \
		| sed 's/"/\\"/g' | sed 's/^/"/g' | sed 's/$/\\n"/g'> usage_text.h || die
	default
}

src_install() {
	dobin ${PN}
	doman man/man1/${PN}.1
	einstalldocs
}
