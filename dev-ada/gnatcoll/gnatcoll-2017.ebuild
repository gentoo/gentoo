# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit multilib multiprocessing autotools python-single-r1

MYP=${PN}-gpl-${PV}

DESCRIPTION="GNAT Component Collection"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed016
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gmp gnat_2016 +gnat_2017 gtk iconv postgres pygobject projects readline
	+shared sqlite static-libs syslog tools"

RDEPEND="dev-lang/gnat-gpl:6.3.0
	${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:* )
	gtk? (
		dev-ada/gtkada[gnat_2017,shared?,static-libs?]
		dev-libs/atk
		dev-libs/glib
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/pango
	)
	pygobject? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite )
	projects? (
		=dev-ada/libgpr-2017*[gnat_2017,shared?,static-libs?]
		dev-ada/xmlada[shared?,static-libs?]
	)"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2017]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	tools? ( static-libs )
	pygobject? ( gtk )
	!gnat_2016 gnat_2017"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	GCC_PV=6.3.0
	default
	mv configure.{in,ac} || die
	sed -i \
		-e "s:@GNATLS@:${CHOST}-gnatls-${GCC_PV}:g" \
		src/gnatcoll-projects.ads \
		src/tools/gnatinspect.adb \
		|| die
	eautoreconf
}

src_configure() {
	GCC=${CHOST}-gcc-${GCC_PV}
	GNATMAKE=${CHOST}-gnatmake-${GCC_PV}
	GNATCHOP=${CHOST}-gnatchop-${GCC_PV}
	if use sqlite; then
		myConf="--with-sqlite=$(get_libdir)"
	else
		myConf="--without-sqlite"
	fi
	if use gtk ; then
		myConf="$myConf --with-gtk=3.0"
	else
		myConf="$myConf --with-gtk=no"
	fi
	econf \
		GNATCHOP="${GNATCHOP}" \
		GNATMAKE="${GNATMAKE}" \
		--with-python \
		$(use_with gmp) \
		$(use_with iconv) \
		$(use_with postgres postgresql) \
		$(use_enable projects) \
		$(use_enable pygobject) \
		$(use_enable readline gpl) \
		$(use_enable readline) \
		$(use_enable syslog) \
		--with-python-exec=${EPYTHON} \
		--enable-shared-python \
		--disable-pygtk \
		CC=${GCC} \
		$myConf
}

src_compile() {
	if use shared; then
		emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v GCC=${GCC} \
			build_library_type/relocatable
	fi
	if use static-libs; then
		emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v GCC=${GCC} \
			build_library_type/static
	fi
	if use tools; then
		emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v GCC=${GCC} \
			build_tools/static
	fi
	python_fix_shebang .
}

src_install() {
	if use shared; then
		emake prefix="${D}usr" install_library_type/relocatable
	fi
	if use static-libs; then
		emake prefix="${D}usr" install_library_type/static
	fi
	if use tools; then
		emake prefix="${D}usr" install_tools/static
	fi
	emake prefix="${D}usr" install_gps_plugin
	einstalldocs
}

src_test() {
	# The test suite is in
	# To run you need to have the ada compiler available as gcc
	# Even in this case there are still some problem
	# Going into the testsuite directory and running
	# ./run.py -v -v
	# run here (having enabled most USE flags)
	true
}
