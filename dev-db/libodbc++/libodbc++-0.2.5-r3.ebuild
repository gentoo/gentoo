# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Provides a subset of the well-known JDBC 2.0(tm) and runs on top of ODBC"
SRC_URI="mirror://sourceforge/libodbcxx/${P}.tar.bz2"
HOMEPAGE="http://libodbcxx.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT=0
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~riscv ~x86"

DEPEND="dev-db/unixODBC
		sys-libs/ncurses"
RDEPEND="${DEPEND}"

SB="${S}-build"
SB_MT="${S}-build-mt"
# QT3 is no longer supported in Gentoo.
#SB_QT="${S}-build_qt"
#SB_QT_MT="${S}-build_qt-mt"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.3-doxygen.patch
	"${FILESDIR}"/${PN}-0.2.3-gcc41.patch
	"${FILESDIR}"/${PN}-0.2.3-gcc44.patch
	"${FILESDIR}"/${PN}-0.2.3-musl-1.2.3-null.patch
)

src_prepare() {
	default

	# Fix configure to use ncurses instead of termcap (bug #103105)
	sed -i -e 's~termcap~ncurses~g' configure || die

	# Fix undeclared ODBCXX_STRING_PERCENT symbol, bug #532356
	sed -i -e 's/ODBCXX_STRING_PERCENT/"%"/' src/dtconv.h || die
}

src_configure() {
	local commonconf buildlist
	commonconf="--with-odbc=${EPREFIX}/usr --without-tests"
	commonconf="${commonconf} --enable-shared"
	# " --enable-threads"

	export ECONF_SOURCE="${S}"
	append-flags -DODBCXX_DISABLE_READLINE_HACK

	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"

	local sd
	for sd in ${buildlist}; do
		einfo "Doing configure pass for $sd"
		mkdir -p "${sd}" || die
		cd "${sd}" || die
		commonconf2=''
		LIBS=''
		[[ "${sd}" == "${SB_MT}" || "${sd}" == "${SB_QT_MT}" ]] && commonconf2="${commonconf2} --enable-threads"
		[[ "${sd}" == "${SB_QT}" || "${sd}" == "${SB_QT_MT}" ]] && commonconf2="${commonconf2} --with-qt"
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
			${commonconf2}
	done
}

src_compile() {
	local buildlist failures sd
	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"
	for sd in ${buildlist}; do
		einfo "Doing compile pass for ${sd}"
		emake -C "${sd}" LIBS='' || failures="${failures} ${sd//${S}-}"
	done
	[[ -n ${failures} ]] && die "Failures: ${failures}"
}

src_install() {
	einstalldocs

	local sd buildlist
	buildlist="${SB} ${SB_MT}"
	#use qt3 && buildlist="${buildlist} $SB_QT $SB_QT_MT"
	for sd in ${buildlist}; do
		einfo "Doing install pass for ${sd}"
		emake -C "${sd}" DESTDIR="${D}" install
	done
	if [[ "${P}" != "${PF}" ]]; then
		mv "${ED}"/usr/share/doc/${P}/* "${ED}"/usr/share/doc/${PF}/ || die
		rmdir "${ED}"/usr/share/doc/${P} || die
	fi
}
