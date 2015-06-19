# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/opencascade/opencascade-6.8.0.ebuild,v 1.3 2015/03/31 20:17:21 ulm Exp $

EAPI=5

inherit autotools eutils check-reqs multilib java-pkg-opt-2 flag-o-matic

DESCRIPTION="Software development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="http://www.opencascade.org/"
SRC_URI="http://files.opencascade.com/OCCT/OCC_${PV}_release/opencascade-${PV}.tgz"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples freeimage gl2ps java qt4 +tbb"

DEPEND="app-eselect/eselect-opencascade
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/tix
	media-libs/ftgl
	virtual/glu
	virtual/opengl
	x11-libs/libXmu
	freeimage? ( media-libs/freeimage )
	gl2ps? ( x11-libs/gl2ps )
	java? ( virtual/jdk:= )
	tbb? ( dev-cpp/tbb )"
RDEPEND="${DEPEND}"

# http://bugs.gentoo.org/show_bug.cgi?id=352435
# http://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt
RESTRICT="bindist mirror"

CHECKREQS_MEMORY="256M"
CHECKREQS_DISK_BUILD="3584M"

pkg_setup() {
	check-reqs_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	epatch \
		"${FILESDIR}"/${P}-fixed-DESTDIR.patch

	# Feed environment variables used by Opencascade compilation
	my_install_dir=${EROOT}usr/$(get_libdir)/${P}/ros
	local my_env_install="#!/bin/sh -f
if [ -z \"\$PATH\" ]; then
	export PATH=VAR_CASROOT/Linux/bin
else
	export PATH=VAR_CASROOT/Linux/bin:\$PATH
fi
if [ -z \"\$LD_LIBRARY_PATH\" ]; then
	export LD_LIBRARY_PATH=VAR_CASROOT/Linux/lib
else
	export LD_LIBRARY_PATH=VAR_CASROOT/Linux/lib:\$LD_LIBRARY_PATH
fi"
	local my_sys_lib=${EROOT}usr/$(get_libdir)
	local my_env="CASROOT=VAR_CASROOT
CSF_MDTVFontDirectory=VAR_CASROOT/src/FontMFT
CSF_LANGUAGE=us
MMGT_CLEAR=1
CSF_EXCEPTION_PROMPT=1
CSF_SHMessage=VAR_CASROOT/src/SHMessage
CSF_MDTVTexturesDirectory=VAR_CASROOT/src/Textures
CSF_XSMessage=VAR_CASROOT/src/XSMessage
CSF_StandardDefaults=VAR_CASROOT/src/StdResource
CSF_PluginDefaults=VAR_CASROOT/src/StdResource
CSF_XCAFDefaults=VAR_CASROOT/src/StdResource
CSF_StandardLiteDefaults=VAR_CASROOT/src/StdResource
CSF_GraphicShr=VAR_CASROOT/Linux/lib/libTKOpenGl.so
CSF_UnitsLexicon=VAR_CASROOT/src/UnitsAPI/Lexi_Expr.dat
CSF_UnitsDefinition=VAR_CASROOT/src/UnitsAPI/Units.dat
CSF_IGESDefaults=VAR_CASROOT/src/XSTEPResource
CSF_STEPDefaults=VAR_CASROOT/src/XSTEPResource
CSF_XmlOcafResource=VAR_CASROOT/src/XmlOcafResource
CSF_MIGRATION_TYPES=VAR_CASROOT/src/StdResource/MigrationSheet.txt
TCLHOME=${EROOT}usr/bin
TCLLIBPATH=${my_sys_lib}
ITK_LIBRARY=${my_sys_lib}/itk$(grep ITK_VER /usr/include/itk.h | sed 's/^.*"\(.*\)".*/\1/')
ITCL_LIBRARY=${my_sys_lib}/itcl$(grep ITCL_VER /usr/include/itcl.h | sed 's/^.*"\(.*\)".*/\1/')
TIX_LIBRARY=${my_sys_lib}/tix$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')
TK_LIBRARY=${my_sys_lib}/tk$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
TCL_LIBRARY=${my_sys_lib}/tcl$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')"

	( 	echo "${my_env_install}"
		echo "${my_env}" | sed -e "s:^:export :" ) \
	| sed -e "s:VAR_CASROOT:${S}:g" > env.sh || die
	source env.sh

	(	echo "PATH=${my_install_dir}/lin/bin"
		echo "LDPATH=${my_install_dir}/lin/$(get_libdir)"
		echo "${my_env}" | sed \
			-e "s:VAR_CASROOT:${my_install_dir}/lin:g" \
			-e "s:/Linux/lib/:/$(get_libdir)/:g" || die
	) > 50${PN}

	append-cxxflags "-fpermissive"

	sed -e "/^AM_C_PROTOTYPES$/d" \
		-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" \
		-e "s:\$qt/include:\$qt/include/qt4:g"\
		-e "s:\$qt/lib:\$qt/$(get_libdir)/qt4:g"\
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--prefix=${my_install_dir}/lin --exec-prefix=${my_install_dir}/lin \
		--with-tcl="${EROOT}usr/$(get_libdir)" --with-tk="${EROOT}usr/$(get_libdir)" \
		--with-freetype="${EROOT}usr" \
		--with-ftgl="${EROOT}usr" \
		$(usex freeimage "--with-freeimage=${EROOT}usr" "") \
		$(usex gl2ps "--with-gl2ps=${EROOT}usr" "") \
		$(usex qt4 "--with-qt=${EROOT}usr" "") \
		$(usex tbb "--with-tbb-include=${EROOT}usr" "") \
		$(usex tbb "--with-tbb-library=${EROOT}usr" "") \
		$(use java && echo "--with-java-include=$(java-config -O)/include" || echo "--without-java-include") \
		$(use_enable debug) \
		$(use_enable !debug production)
}

src_install() {
	emake DESTDIR="${D}" install

	prune_libtool_files

	# Symlinks for keeping original OpenCascade folder structure and
	# add a link lib to $(get_libdir)  if we are e.g. on amd64 multilib
	if [ "$(get_libdir)" != "lib" ]; then
		dosym "$(get_libdir)" "${my_install_dir}/lin/lib"
	fi

	insinto /etc/env.d/${PN}
	newins 50${PN} ${PV}

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r data
		doins -r samples
	fi
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/{overview,pdf,refman}
	fi
}

pkg_postinst() {
	eselect ${PN} set ${PV}
	einfo
	elog "After upgrading OpenCASCADE you may have to rebuild packages depending on it."
	elog "You get a list by running \"equery depends sci-libs/opencascade\""
	elog "revdep-rebuild does NOT suffice."
	einfo
}
