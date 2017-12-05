# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

MY_P=${PN}-src-${PV}

DESCRIPTION="Tool for generating Qt bindings for Qt Script"
HOMEPAGE="https://code.google.com/p/qtscriptgenerator/"
SRC_URI="https://dev.gentoo.org/~johu/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug"

DEPEND="
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4[accessibility]
	dev-qt/qtopengl:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4[accessibility]
	dev-qt/qtxmlpatterns:4
	media-libs/phonon[qt4]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# remove phonon
	sed -i "/typesystem_phonon.xml/d" generator/generator.qrc || die "sed failed"
	sed -i "/qtscript_phonon/d" qtbindings/qtbindings.pro || die "sed failed"
	sed -i "/qtscript_webkit/d" qtbindings/qtbindings.pro || die "sed failed"

	use arm && eapply "${FILESDIR}"/${P}-arm.patch
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
