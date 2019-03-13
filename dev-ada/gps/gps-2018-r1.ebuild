# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 autotools desktop llvm multilib

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0cf627c7a4475261f97ceb
	-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a59 ->
		libadalang-tools-gpl-2018-src.tar.gz
	http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a61 ->
		gtk+-3.14.15-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2017 +gnat_2018"

RDEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll-db[gnat_2017=,gnat_2018=,gnatcoll_db2ada,gnatinspect,xref]
	dev-ada/gnatcoll-bindings[gnat_2017=,gnat_2018=,python]
	~dev-ada/gtkada-2018[gnat_2017=,gnat_2017=]
	dev-ada/libadalang[gnat_2017=,gnat_2018=]
	dev-libs/gobject-introspection
	dev-libs/libffi
	gnat_2017? ( sys-devel/llvm:5 )
	gnat_2018? (
		|| (
			sys-devel/llvm:6
			sys-devel/llvm:7
		)
	)
	sys-devel/clang:=
	x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme
	dev-python/pep8[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

RESTRICT="test"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	if use gnat_2017; then
		GCC_PV=6.3.0
		LLVM_MAX_SLOT=5
	else
		GCC_PV=7.3.1
		LLVM_MAX_SLOT=7
	fi
	GNATMAKE=gnatmake-${GCC_PV}
	GNATDRV=gnat-${GCC_PV}
	GNATLS=gnatls-${GCC_PV}
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	GCC_PV=7.3.1
	default
	sed -i \
		-e "s:@GNATMAKE@:${CHOST}-${GNATMAKE}:g" \
		-e "s:@GNAT@:${CHOST}-${GNATDRV}:g" \
		-e "s:@GNATLS@:${CHOST}-${GNATLS}:g" \
		share/support/core/toolchains.py \
		share/support/core/projects.py \
		|| die
	mv "${WORKDIR}"/libadalang-tools-src laltools
	echo "#!/bin/bash" > gps.sh
	echo "export LD_LIBRARY_PATH=/usr/$(get_libdir)/gps" >> gps.sh
	echo 'exec /usr/bin/gps_exe "$@"' >> gps.sh
	cd ../gtk+-3.14.15-src
	sed -i \
		-e "/^libadd/s:=.*$:= \\\:" \
		-e "/^deps/s:=.*$:= \\\:" \
		../gtk+-3.14.15-src/gtk/Makefile.in
}

src_configure() {
	econf \
		GNATMAKE=/usr/bin/${GNATMAKE} \
		GNATDRV=/usr/bin/${GNATDRV} \
		--with-clang=$(llvm-config --libdir)
	cd ../gtk+-3.14.15-src
	econf --disable-cups
}

src_compile() {
	emake -C gps GPRBUILD_FLAGS="-v ${MAKEOPTS} \
		-XGPR_BUILD=relocatable" \
		Build=Production
	gprbuild -v -p -Pcli/cli.gpr ${MAKEOPTS} -XLIBRARY_TYPE=relocatable \
		-XGPR_BUILD=relocatable -cargs:Ada ${ADAFLAGS} || die
	cd ../gtk+-3.14.15-src
	emake -C gtk/inspector
	emake -C gtk gtk.gresource.xml gtkdbusgenerated.c gtkdbusgenerated.h
	emake -C gtk libgtk-3.la
}

src_install() {
	default
	make_desktop_entry "${PN}" "GPS" "${EPREFIX}/usr/share/gps/icons/hicolor/32x32/apps/gps_32.png" "Development;IDE;"
	mv "${D}"/usr/bin/gps{,_exe}
	newbin gps.sh gps
	cd ../gtk+-3.14.15-src
	emake -C gtk DESTDIR="${D}" install-libLTLIBRARIES
	rm "${D}"/usr/$(get_libdir)/libgtk-3.{la,so,so.0} || die
	dosym "${D}"/usr/$(get_libdir)/libgtk-3.so.0.* /usr/$(get_libdir)/gps/libgtk-3.so.0
}
