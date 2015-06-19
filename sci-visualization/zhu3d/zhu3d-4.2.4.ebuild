# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/zhu3d/zhu3d-4.2.4.ebuild,v 1.6 2013/03/02 23:29:22 hwoarang Exp $

EAPI=4

LANGS="cs de es fr zh"

inherit eutils qt4-r2

DESCRIPTION="Interactive 3D mathematical function viewer"
HOMEPAGE="http://sourceforge.net/projects/zhu3d"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	virtual/glu
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gold.patch" )

src_prepare() {
	qt4-r2_src_prepare

	local datadir=/usr/share/${PN}
	sed \
		-e "s:^SYSDIR=:SYSDIR=${datadir}/system:" \
		-e "s:^TEXDIR=:TEXDIR=${datadir}/textures:" \
		-e "s:^WORKDIR=:WORKDIR=${datadir}/work:" \
		-e "s:^DOCDIR=:DOCDIR=/usr/share/doc/${PF}/html:" \
		-i ${PN}.pri || die "sed zhu3d.pri failed"

	sed \
		-e "/# Optimisation/,/# Include/d" \
		-i zhu3d.pro || die "optimisation sed failed"
}

src_install() {
	# not working: emake install INSTALL_ROOT="${D}" || die
	dobin zhu3d

	dodoc {readme,src/changelog}.txt
	dohtml doc/*.png doc/${PN}_en.html

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
	make_desktop_entry ${PN} "Zhu3D Function Viewer" ${PN} "Education;Science;Math;Qt"
}
