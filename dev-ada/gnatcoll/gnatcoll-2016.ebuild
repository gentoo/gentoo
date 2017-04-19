# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit multilib multiprocessing autotools python-single-r1

MYP=${PN}-gpl-${PV}

DESCRIPTION="GNAT Component Collection"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5739942ac7a447658d00e1e7 -> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gmp iconv postgresql projects python readline +shared sqlite static syslog"

RDEPEND="dev-lang/gnat-gpl
	gmp? ( dev-libs/gmp:* )
	postgresql? ( dev-db/postgresql:* )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite )
	projects? (
		dev-ada/gprbuild[static?,shared?]
	)"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

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
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myConf=""
	if use sqlite; then
		myConf="$myConf --with-sqlite=$(get_libdir)"
	else
		myConf="$myConf --without-sqlite"
	fi
	econf \
		GNATCHOP="${GNATCHOP}" \
		GNATMAKE="${GNATMAKE}" \
		$(use_with gmp) \
		$(use_with iconv) \
		$(use_with postgresql) \
		$(use_enable projects) \
		$(use_with python) \
		$(use_enable readline gpl) \
		$(use_enable readline) \
		$(use_enable syslog) \
		--with-python-exec=${EPYTHON} \
		--enable-shared-python \
		--without-gtk \
		--disable-pygtk \
		--disable-pygobject \
		$myConf
}

src_compile() {
	if use shared; then
		emake PROCESSORS=$(makeopts_jobs) build_library_type/relocatable
	fi
	if use static; then
		emake PROCESSORS=$(makeopts_jobs) build_library_type/static
	fi
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
	dodoc -r features-* known-problems-* examples
	mv "${D}"/usr/share/doc/${PN}/GNATColl.pdf "${D}"/usr/share/doc/${PF}/
	mv "${D}"/usr/share/doc/${PN}/html/html "${D}"/usr/share/doc/${PF}/
	rm -rf "${D}"/usr/share/doc/${PN}
	use python && python_fix_shebang "${ED}"usr/share/gnatcoll/dborm.py
}

src_test() {
	true
}
