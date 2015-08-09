# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils gnat versionator

Name="GtkAda-gpl"
MajorPV=$(get_version_component_range 1-2)
DESCRIPTION="Gtk+ bindings to the Ada language"
HOMEPAGE="https://libre.adacore.com/GtkAda/"
SRC_URI="mirror://gentoo/${Name}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="nls opengl"

DEPEND="virtual/ada
	>=x11-libs/cairo-1.2.6
	>=dev-libs/glib-2.12.4
	>=x11-libs/pango-1.14.9
	>=dev-libs/atk-1.12.1
	>=x11-libs/gtk+-2.10.9
	>=sys-apps/sed-4"
RDEPEND=""

S="${WORKDIR}/${Name}-${PV}"

# only needed for gcc-3.x based gnat profiles, but matching them individually
# would be insane
QA_EXECSTACK="${AdalibLibTop:1}/*/gtkada/libgtkada-${MajorPV}.so.0"

src_unpack() {
	unpack ${A}

	cd "${S}"
	sed -i -e "s:-aI\$prefix/include/gtkada:-aI${AdalibSpecsDir}/gtkada:" \
		src/tools/gtkada-config.in

	# disable building tests to avoid waisting time while building for every
	# profile. The tests are nonetheless installed under doc dir.
	sed -i -e "/testgtk_dir/d" Makefile.in

	# remove lib stripping
	sed -i -e "s: strip \$(LIBNAME)::" src/Makefile.common.in
}

lib_compile() {
	# some profile specific fixes first
	sed -i -e "s:\$prefix/lib\(/gtkada\)*:${AdalibLibTop}/$1/gtkada:" \
		src/tools/gtkada-config.in

	local myconf
	use opengl && myconf="--with-GL=auto" || myconf="--with-GL=no"

	econf ${myconf} $(use_enable nls) || die "./configure failed"

	# bug #279962
	emake -j1 GNATFLAGS="${ADACFLAGS}" || die
}

lib_install() {
	# make install misses all the .so and .a files and otherwise creates more
	# problems than it's worth. Will do everything manually
	mkdir -p "${DL}"
	mv src/lib-obj/* src/*/obj/* src/tools/gtkada-config "${DL}"
	rm "${DL}"/*.o
	chmod 0444 "${DL}"/*.ali
	chmod 0755 "${DL}"/gtkada-config
}

src_install() {
	#set up environment
	echo "PATH=%DL%" > ${LibEnv}
	echo "LDPATH=%DL%" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=${AdalibSpecsDir}/${PN}" >> ${LibEnv}

	gnat_src_install

	#specs
	cd "${S}"/src
	dodir "${AdalibSpecsDir}/${PN}"
	insinto "${AdalibSpecsDir}/${PN}"
	doins *.ad? glade/*.ad? gnome/*.ad? opengl/*.{ad?,c,h}

	#docs
	cd "${S}"
	dodoc ANNOUNCE AUTHORS README
	cp -dPr examples/ testgtk/ "${D}/usr/share/doc/${PF}"
	cd "${S}"/docs
	doinfo gtkada_ug/gtkada_ug.info
	ps2pdf gtkada_ug/gtkada_ug.ps
	ps2pdf gtkada_rm/gtkada_rm.ps
	cp gtkada_ug.pdf gtkada_rm.pdf "${D}/usr/share/doc/${PF}"
	dohtml -r gtkada_ug/{gtkada_ug.html,boxes.gif,hierarchy.jpg}
	cp -dPr gtkada_rm/gtkada_rm/ "${D}/usr/share/doc/${PF}/html"

	# utility stuff
	cd "${S}"
	dodir "${AdalibDataDir}/${PN}"
	insinto "${AdalibDataDir}/${PN}"
	doins -r xml/gtkada.xml projects/
}

pkg_postinst() {
	eselect gnat update
	einfo "The environment has been set up to make gnat automatically find files for"
	einfo "GtkAda. In order to immediately activate these settings please do:"
	einfo "   env-update && source /etc/profile"
	einfo "Otherwise the settings will become active next time you login"
}
