# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/libodbc++/libodbc++-0.2.5-r2.ebuild,v 1.1 2015/05/22 06:39:56 pinkbyte Exp $

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="C++ class library that provides a subset of the well-known JDBC 2.0(tm) and runs on top of ODBC"
SRC_URI="mirror://sourceforge/libodbcxx/${P}.tar.bz2"
HOMEPAGE="http://libodbcxx.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT=0
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86"

IUSE="static-libs"

DEPEND="dev-db/unixODBC
		sys-libs/ncurses"
RDEPEND="${DEPEND}"

SB="${S}-build"
SB_MT="${S}-build-mt"
# QT3 is no longer supported in Gentoo.
#SB_QT="${S}-build_qt"
#SB_QT_MT="${S}-build_qt-mt"

src_prepare() {
	#epatch "${FILESDIR}"/${PN}-0.2.3-std-streamsize.patch
	epatch "${FILESDIR}"/${PN}-0.2.3-doxygen.patch
	epatch "${FILESDIR}"/${PN}-0.2.3-gcc41.patch
	#epatch "${FILESDIR}"/${PN}-0.2.3-gcc43.patch
	#epatch "${FILESDIR}"/${PN}-0.2.3-typecast.patch
	epatch "${FILESDIR}"/${PN}-0.2.3-gcc44.patch

	# Fix configure to use ncurses instead of termcap (bug #103105)
	sed -i -e 's~termcap~ncurses~g' configure

	# Fix undeclared ODBCXX_STRING_PERCENT symbol, bug #532356
	sed -i -e 's/ODBCXX_STRING_PERCENT/"%"/' src/dtconv.h || die

	epatch_user
}

src_configure() {
	local commonconf buildlist
	commonconf="--with-odbc=/usr --without-tests"
	commonconf="${commonconf} $(use_enable static-libs static) --enable-shared"
	# " --enable-threads"

	export ECONF_SOURCE="${S}"
	append-flags -DODBCXX_DISABLE_READLINE_HACK

	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"

	for sd in ${buildlist}; do
		einfo "Doing configure pass for $sd"
		mkdir -p "${sd}"
		cd "${sd}"
		commonconf2=''
		LIBS=''
		[ "${sd}" == "${SB_MT}" -o "${sd}" == "${SB_QT_MT}" ] && commonconf2="${commonconf2} --enable-threads"
		[ "${sd}" == "${SB_QT}" -o "${sd}" == "${SB_QT_MT}" ] && commonconf2="${commonconf2} --with-qt"
		# isql++ tool fails to compile:
		#libodbc++-0.2.5/isql++/isql++.cpp: In constructor 'Isql::Isql(odbc::Connection*)':
		#libodbc++-0.2.5/isql++/isql++.cpp:275: error: invalid cast to function type 'char** ()()'
		#[ "${sd}" == "${SB}" ] && commonconf2="${commonconf2} --with-isqlxx"
		# Upstream configure is broken as well, passing --without or
		# --with-isqlxx=no will turn it ON instead of forcing it off.
		#commonconf2="${commonconf2} _-without-isqlxx"
		[ "${sd}" == "${SB_QT}" ] && commonconf2="${commonconf2} --with-qtsqlxx"
		export LIBS
		# using without-qt breaks the build
		#--without-qt \
		econf \
			${commonconf} \
			${commonconf2} \
			|| die "econf failed"
	done
}

src_compile() {
	local buildlist failures
	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"
	for sd in ${buildlist}; do
		einfo "Doing compile pass for $sd"
		cd "${sd}"
		emake LIBS='' || failures="${failures} ${sd//${S}-}"
	done
	[ -n "${failures}" ] && die "Failures: ${failures}"
}

src_install () {
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO

	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"
	for sd in ${buildlist}; do
		einfo "Doing install pass for $sd"
		cd ${sd}
		emake DESTDIR="${D}" install
	done
	if [[ "${P}" != "${PF}" ]]; then
		mv "${D}"/usr/share/doc/${P}/* "${D}"/usr/share/doc/${PF}/
		rmdir "${D}"/usr/share/doc/${P}
	fi
}
