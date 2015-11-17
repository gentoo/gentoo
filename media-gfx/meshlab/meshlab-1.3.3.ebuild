# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator multilib

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
	sys-libs/libunwind
	sci-libs/mpir"
RDEPEND="${DEPEND}"

S="${WORKDIR}/meshlab/src"

src_prepare() {
	cd "${WORKDIR}"
	epatch	"${FILESDIR}/${PV}"/gcc-4.7.patch \
		"${FILESDIR}/${PV}"/lapack.patch \
		"${FILESDIR}/${PV}"/mpir.patch \
		"${FILESDIR}/${PV}"/qt-4.8.patch \
		"${FILESDIR}/${PV}"/rpath.patch \
		"${FILESDIR}/${PV}"/pluginmanager.patch \
		"${FILESDIR}/${PV}"/meshrender.patch \
		"${FILESDIR}/${PV}"/rmmeshrender.patch \
		"${FILESDIR}/${PV}"/rfx.patch
}

src_configure() {
	qmake -recursive external/external.pro
	qmake -recursive meshlab_full.pro
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
