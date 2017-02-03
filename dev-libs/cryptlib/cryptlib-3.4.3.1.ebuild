# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 eutils flag-o-matic multilib toolchain-funcs versionator

MY_PV="${PV//.}"

DESCRIPTION="Powerful security toolkit for adding encryption to software"
HOMEPAGE="http://www.cs.auckland.ac.nz/~pgut001/cryptlib/"
DOC_PREFIX="${PN}-$(get_version_component_range 1-2 ${PV}).0"
SRC_URI="ftp://ftp.franken.de/pub/crypt/cryptlib/cl${MY_PV}.zip
	doc? ( mirror://gentoo/${DOC_PREFIX}-manual.pdf.bz2 )"

LICENSE="Sleepycat"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc ldap odbc python"

S="${WORKDIR}"

RDEPEND="sys-libs/zlib
	ldap? ( net-nds/openldap )
	odbc? ( dev-db/unixODBC )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-zlib.patch"
)

src_unpack() {
	# we need the -a option, so we can not use 'unpack'
	unzip -qoa "${DISTDIR}/cl${MY_PV}.zip" || die
	use doc && unpack "${DOC_PREFIX}-manual.pdf.bz2"
}

wrap_python() {
	if use python; then
		cd bindings || die
		distutils-r1_${1}
	fi
}

src_prepare() {
	default

	rm -fr zlib || die

	# we want our own CFLAGS ;-)
	sed -i -e "s:-m.*=pentium::g" -e "s:-fomit-frame-pointer::g" -e "s:-O2::g" \
		-e "s:-O3::g" -e "s:-O4::g"	makefile || die "sed makefile failed"
	sed -i -e "s/-march=[[:alnum:]\.=-]*//g" -e "s/-mcpu=[[:alnum:]\.=-]*//g" \
		-e "s:-O2::g" -e "s:-O3::g" tools/ccopts.sh || die "sed tools/ccopts.sh failed"

	# change 'make' to '$(MAKE)'
	sed -i -e "s:@\?make:\$(MAKE):g" makefile || die "sed makefile failed"

	# NOTICE:
	# Because of stack execution
	# assembly parts are disabled.
	sed -i -e 's:i\[3,4,5,6\]86:___:g' makefile || die "sed makefile failed"

	# Fix version number of shared library.
	sed -i -e 's/PLV="2"/PLV="3"/' tools/buildall.sh || die "sed tools/buildall.sh failed"

	wrap_python ${FUNCNAME}
}

src_compile() {
	local libname="libcl.so.$(get_version_component_range 1-3 ${PV})"

	# At least -O2 is needed.
	replace-flags -O  -O2
	replace-flags -O0 -O2
	replace-flags -O1 -O2
	replace-flags -Os -O2
	is-flagq -O* || append-flags -O2

	append-flags "-fPIC"
	append-cppflags "-D__UNIX__ -DOSVERSION=2 -DNDEBUG -I."

	if [ -f /usr/include/pthread.h -a \
	`grep -c PTHREAD_MUTEX_RECURSIVE /usr/include/pthread.h` -ge 0 ] ; then
		append-cppflags "-DHAS_RECURSIVE_MUTEX"
	fi
	if [ -f /usr/include/pthread.h -a \
	`grep -c PTHREAD_MUTEX_ROBUST /usr/include/pthread.h` -ge 0 ] ; then
		append-cppflags "-DHAS_ROBUST_MUTEX"
	fi

	use ldap && append-cppflags -DHAS_LDAP
	use odbc && append-cppflags -DHAS_ODBC

	emake directories
	emake toolscripts
	emake CC="$(tc-getCC)" CFLAGS="${CPPFLAGS} ${CFLAGS} -c" STRIP=true Linux

	emake TARGET=${libname} OBJPATH="./shared-obj/" CC="$(tc-getCC)" \
		CFLAGS="${CPPFLAGS} ${CFLAGS} -c" STRIP=true Linux

	if use python; then
		# Without this python will link against the static lib
		ln -s libcl.so.${PV} libcl.so || die

		# Python bindings don't work with -O2 and higher.
		replace-flags -O* -O1

		wrap_python ${FUNCNAME}
	fi
}

src_install() {
	local libname="libcl.so.$(get_version_component_range 1-3 ${PV})"
	local solibname="libcl.so.$(get_version_component_range 1-2 ${PV})"

	dolib.so "${libname}"
	dosym "${libname}" "/usr/$(get_libdir)/${solibname}"
	dosym "${solibname}" "/usr/$(get_libdir)/libcl.so"
	dolib.a "libcl.a"

	doheader cryptlib.h

	dodoc README
	if use doc; then
		newdoc "${DOC_PREFIX}-manual.pdf" "manual.pdf"
	fi

	wrap_python ${FUNCNAME}
}
