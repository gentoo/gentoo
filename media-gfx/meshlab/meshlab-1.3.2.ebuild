# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/meshlab/meshlab-1.3.2.ebuild,v 1.2 2014/09/11 11:27:50 kensington Exp $

EAPI=5

inherit eutils versionator multilib qt4-r2

DESCRIPTION="A mesh processing system"
HOMEPAGE="http://meshlab.sourceforge.net/"
MY_PV="$(delete_all_version_separators ${PV})"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/MeshLab%20v${PV}/MeshLabSrc_AllInc_v${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-cpp/eigen:3
	dev-cpp/muParser
	dev-qt/qtcore:4
	dev-qt/qtopengl:4
	media-libs/glew
	media-libs/qhull
	=media-libs/lib3ds-1*
	media-libs/openctm
	sci-libs/levmar
	sys-libs/libunwind"
RDEPEND="${DEPEND}"

S="${WORKDIR}/meshlab/src"

src_prepare() {
	rm "${WORKDIR}"/meshlab/src/distrib/plugins/*.xml
	rm "${WORKDIR}"/meshlab/src/meshlabplugins/filter_qhull/qhull_tools.h
	cd ${PORTAGE_BUILDDIR}
	#patches from debian repo
	cd "${WORKDIR}"
	epatch	"${FILESDIR}/${PV}"/01_crash-on-save.patch \
		"${FILESDIR}/${PV}"/02_cstddef.patch \
		"${FILESDIR}/${PV}"/03_disable-updates.patch \
		"${FILESDIR}/${PV}"/05_externals.patch \
		"${FILESDIR}/${PV}"/06_format-security.patch \
		"${FILESDIR}/${PV}"/07_gcc47.patch \
		"${FILESDIR}/${PV}"/08_lib3ds.patch \
		"${FILESDIR}/${PV}"/09_libbz2.patch \
		"${FILESDIR}/${PV}"/10_muparser.patch \
		"${FILESDIR}/${PV}"/11_openctm.patch \
		"${FILESDIR}/${PV}"/12_overflow.patch \
		"${FILESDIR}/${PV}"/13_pluginsdir.patch \
		"${FILESDIR}/${PV}"/14_ply_numeric.patch \
		"${FILESDIR}/${PV}"/15_qhull.patch \
		"${FILESDIR}/${PV}"/16_shadersdir.patch \
		"${FILESDIR}/${PV}"/17_structuresynth.patch \
		"${FILESDIR}/${PV}"/18_glew.c18p1.patch \
		"${FILESDIR}/${PV}"/19_CONFLICTS_IN_rpath.patch \
		"${FILESDIR}/${PV}"/20_rpath.c18p2.patch \
		"${FILESDIR}/${PV}"/21_RESOLUTION.patch \
		"${FILESDIR}/${PV}"/22_aliasing.patch
}

src_configure() {
	eqmake4 external/external.pro
	eqmake4 meshlab_full.pro
}

src_compile() {
	cd external && emake
	cd .. && emake
}

src_install() {
	dobin distrib/{meshlab,meshlabserver}
	dolib distrib/libcommon.so.1.0.0
	dosym libcommon.so.1.0.0 /usr/$(get_libdir)/libcommon.so.1
	dosym libcommon.so.1 /usr/$(get_libdir)/libcommon.so

	exeinto /usr/$(get_libdir)/meshlab/plugins
	doexe distrib/plugins/*.so

	insinto /usr/share/meshlab/shaders
	doins -r distrib/shaders/*
	newicon "${S}"/meshlab/images/eye64.png "${PN}".png
	make_desktop_entry meshlab "Meshlab"
}
