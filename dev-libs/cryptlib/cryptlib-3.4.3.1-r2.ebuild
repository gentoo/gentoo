# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="doc ldap odbc python static-libs test"

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

# test access the network
RESTRICT="test"

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

	wrap_python ${FUNCNAME}
}

src_compile() {
	use ldap && append-cppflags -DHAS_LDAP
	use odbc && append-cppflags -DHAS_ODBC

	export DISABLE_AUTODETECT=1
	emake EXTRA_CFLAGS="${CPPFLAGS} ${CFLAGS}" shared
	use static-libs && emake EXTRA_CFLAGS="${CPPFLAGS} ${CFLAGS}" default
	use test && emake EXTRA_CFLAGS="${CPPFLAGS} ${CFLAGS}" stestlib

	#
	# Without this:
	# 1. python will link against the static lib
	# 2. tests will not work find soname.
	#
	local libname="libcl.so.$(get_version_component_range 1-3 ${PV})"
	local solibname="libcl.so.$(get_version_component_range 1-2 ${PV})"
	ln -s "${libname}" "${solibname}" || die
	ln -s "${solibname}" libcl.so || die

	if use python; then
		wrap_python ${FUNCNAME}
	fi
}

src_test() {
	LD_LIBRARY_PATH="." ./stestlib || die "test failed"
}

src_install() {
	einstalldocs

	doheader cryptlib.h

	dolib.so libcl.so*
	use static-libs && dolib.a libcl.a

	if use doc; then
		newdoc "${DOC_PREFIX}-manual.pdf" "manual.pdf"
	fi

	wrap_python ${FUNCNAME}
}
