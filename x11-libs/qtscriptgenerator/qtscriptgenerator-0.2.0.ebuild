# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qtscriptgenerator/qtscriptgenerator-0.2.0.ebuild,v 1.11 2015/06/23 13:54:15 pesa Exp $

EAPI=4

inherit eutils qmake-utils

MY_P=${PN}-src-${PV}

DESCRIPTION="Tool for generating Qt bindings for Qt Script"
HOMEPAGE="http://code.google.com/p/qtscriptgenerator/"
SRC_URI="http://qtscriptgenerator.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="debug kde"

DEPEND="
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4[accessibility]
	dev-qt/qtopengl:4
	!kde? ( || (
		dev-qt/qtphonon:4
		media-libs/phonon[qt4]
	) )
	kde? ( media-libs/phonon[qt4] )
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4[accessibility]
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# remove phonon
	sed -i "/typesystem_phonon.xml/d" generator/generator.qrc || die "sed failed"
	sed -i "/qtscript_phonon/d" qtbindings/qtbindings.pro || die "sed failed"

	use arm && epatch "${FILESDIR}"/${P}-arm.patch
}

src_configure() {
	cd "${S}"/generator || die
	eqmake4 generator.pro

	cd "${S}"/qtbindings || die
	eqmake4 qtbindings.pro
}

src_compile() {
	cd "${S}"/generator || die
	emake
	./generator --include-paths="$(qt4_get_headerdir)" || die

	cd "${S}"/qtbindings || die
	emake
}

src_install() {
	insinto "$(qt4_get_libdir)"/plugins/script
	insopts -m0755
	doins "${S}"/plugins/script/*
}
