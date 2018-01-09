# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils

DESCRIPTION="Interactive 3D mathematical function viewer"
HOMEPAGE="https://sourceforge.net/projects/zhu3d"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"

DOCS=( {readme,src/changelog}.txt )
HTML_DOCS=( doc/. )

PATCHES=( "${FILESDIR}"/${P}-qt5.patch )

src_prepare() {
	default

	local datadir=/usr/share/${PN}
	sed \
		-e "s:^SYSDIR=:SYSDIR=${datadir}/system:" \
		-e "s:^TEXDIR=:TEXDIR=${datadir}/textures:" \
		-e "s:^WORKDIR=:WORKDIR=${datadir}/work:" \
		-e "s:^DOCDIR=:DOCDIR=/usr/share/doc/${PF}/html:" \
		-i ${PN}.pri || die "sed zhu3d.pri failed"

	sed \
		-e "/# Optimisation/,/# Include/d" \
		-i ${PN}.pro || die "optimisation sed failed"
}

src_configure() {
	eqmake5 zhu3d.pro
}

src_install() {
	# not working: emake install INSTALL_ROOT="${D}" || die
	dobin zhu3d

	einstalldocs

	local lang
	for lang in ${LANGS} ; do
		if use linguas_${lang} ; then

			insinto /usr/share/${PN}/system/languages
			doins system/languages/${PN}_${lang}.qm

			if [ -e doc/${PN}_${lang}.html ] ; then
				dohtml doc/${PN}_${lang}.html
			fi
		fi
	done

	insinto /usr/share/${PN}
	doins -r work/textures

	insinto /usr/share/${PN}/work
	doins -r work/*.zhu work/slideshow

	insinto /usr/share/${PN}/system
	doins -r system/*.zhu system/icons

	doicon system/icons/${PN}.png
	make_desktop_entry ${PN} "Zhu3D Function Viewer" \
		${PN} "Education;Science;Math;Qt"
}
