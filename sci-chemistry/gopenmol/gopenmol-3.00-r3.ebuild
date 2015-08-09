# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1

DESCRIPTION="Tool for the visualization and analysis of molecular structures"
HOMEPAGE="http://www.csc.fi/gopenmol/"
SRC_URI="${HOMEPAGE}/distribute/${P}-linux.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-lang/tk
	dev-tcltk/bwidget
	media-libs/freeglut
	virtual/jpeg
	virtual/opengl
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}"

RESTRICT="mirror"
S="${WORKDIR}/gOpenMol-${PV}/src"

src_prepare() {
	cd ..
	epatch \
		"${FILESDIR}"/${PV}-include-config-for-plugins.patch \
		"${FILESDIR}"/${PV}-multilib.patch \
		"${FILESDIR}"/${PV}-tcl8.6.patch \
		"${FILESDIR}"/${PV}-impl-dec.patch

	sed \
		-e "s:GENTOOLIBDIR:$(get_libdir):g" \
		-i src/{config.mk.ac,plugins/config.mk.ac} || die
	sed "/GOM_TEMP/s:^.*$:GOM_TEMP=\"${EPREFIX}/tmp/:g" -i environment.txt || die
}

src_compile() {
	default

	# Plugins and Utilities are not built by default
	cd "${S}"/plugins && emake
	cd "${S}"/utility && emake
}

src_install() {
	einstall

	cd "${S}"/plugins && einstall
	cd "${S}"/utility && einstall

	dosym ../$(get_libdir)/gOpenMol-${PV}/bin/${PN} /usr/bin/${PN}

	dodoc "${ED}"/usr/share/gOpenMol-${PV}/{docs/*,README*} || die

	dodir /usr/share/doc/${PF}/html
	mv -T "${ED}"/usr/share/gOpenMol-${PV}/help "${ED}"/usr/share/doc/${PF}/html || die
	mv "${ED}"/usr/share/gOpenMol-${PV}/utility "${ED}"/usr/share/doc/${PF}/html || die

	rm -rf \
		"${ED}"/usr/$(get_libdir)/gOpenMol-${PV}/{src,install} \
		"${ED}"/usr/share/gOpenMol-${PV}/{docs,README*,COPYRIGHT} || die

	cat >> "${T}"/20${PN} <<- EOF
	GOM_ROOT="${EPREFIX}"/usr/$(get_libdir)/gOpenMol-${PV}/
	GOM_DATA="${EPREFIX}"/usr/share/gOpenMol-${PV}/data
	GOM_HELP="${EPREFIX}"/usr/share/doc/${PVR}/html
	GOM_DEMO="${EPREFIX}"/usr/share/gOpenMol-${PV}/demo
	EOF

	doenvd "${T}"/20${PN}
}

pkg_postinst() {
	einfo "Run gOpenMol using the rungOpenMol script."
}
