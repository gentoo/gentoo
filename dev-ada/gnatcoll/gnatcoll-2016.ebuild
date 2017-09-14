# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit multilib multiprocessing autotools python-single-r1

MYP=${PN}-gpl-${PV}

DESCRIPTION="GNAT Component Collection"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5739942ac7a447658d00e1e7
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gmp gnat_2016 gnat_2017 gtk iconv postgresql pygobject projects readline
	+shared sqlite static syslog tools"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:* )
	gtk? (
		dev-ada/gtkada[gnat_2016=,gnat_2017=,shared?,static?]
		dev-libs/atk
		dev-libs/glib
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/pango
	)
	pygobject? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
	postgresql? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite )
	projects? (
		=dev-ada/gprbuild-2016[gnat_2016=,gnat_2017=,shared?,static?]
	)"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016=,gnat_2017=]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	pygobject? ( gtk )
	^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
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
		$(use_with postgresql) \
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
	if use static; then
		emake PROCESSORS=$(makeopts_jobs) GPRBUILD_OPTIONS=-v GCC=${GCC} \
			build_library_type/static
	fi
	python_fix_shebang .
}

src_install() {
	if use shared; then
		emake prefix="${D}usr" install_library_type/relocatable
	fi
	if use static; then
		emake prefix="${D}usr" install_library_type/static
	fi
	emake prefix="${D}usr" install_gps_plugin
	einstalldocs
	dodoc -r features-* known-problems-*
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
