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
IUSE="gmp gtk iconv postgresql pygobject projects readline +shared sqlite
	static syslog"

RDEPEND="dev-lang/gnat-gpl
	${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:* )
	gtk? (
		dev-ada/gtkada
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
		dev-ada/gprbuild[static?,shared?]
	)"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	pygobject? ( gtk )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	GNATMAKE="${GCC/gcc/gnatmake}"
	GNATCHOP="${GCC/gcc/gnatchop}"
	if [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-4.9.4 in make.conf"
		die "ada compiler not available"
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
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
		$myConf
}

src_compile() {
	if use shared; then
		emake PROCESSORS=$(makeopts_jobs) build_library_type/relocatable
	fi
	if use static; then
		emake PROCESSORS=$(makeopts_jobs) build_library_type/static
	fi
	python_fix_shebang .
}

src_install() {
	if use shared; then
		emake DESTDIR="${D}" install_library_type/relocatable
	fi
	if use static; then
		emake DESTDIR="${D}" install_library_type/static
	fi
	emake DESTDIR="${D}" install_gps_plugin
	einstalldocs
	dodoc -r features-* known-problems-*
	mv "${D}"/usr/share/doc/${PN}/GNATColl.pdf "${D}"/usr/share/doc/${PF}/
	mv "${D}"/usr/share/doc/${PN}/html/html "${D}"/usr/share/doc/${PF}/
	mv "${D}"/usr/share/examples/${PN} "${D}"/usr/share/doc/${PF}/examples
	rm -rf "${D}"/usr/share/doc/${PN}
	rmdir "${D}"/usr/share/examples
	docompress -x /usr/share/doc/${PF}/examples
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
