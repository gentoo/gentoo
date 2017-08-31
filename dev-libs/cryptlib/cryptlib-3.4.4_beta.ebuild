# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 flag-o-matic multilib toolchain-funcs versionator

MY_PV="${PV//.}"
MY_PV="${MY_PV//_}"

DESCRIPTION="Powerful security toolkit for adding encryption to software"
HOMEPAGE="http://www.cs.auckland.ac.nz/~pgut001/cryptlib/"
DOC_PREFIX="${PN}-$(get_version_component_range 1-2 ${PV}).0"
SRC_URI="http://www.cypherpunks.to/~peter/cl${MY_PV}.zip
	doc? ( http://www.cypherpunks.to/~peter/manual.pdf -> ${P}-manual.pdf )"

LICENSE="Sleepycat"
KEYWORDS=""
SLOT="0"
IUSE="doc ldap odbc python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}"

RDEPEND="sys-libs/zlib
	ldap? ( net-nds/openldap )
	odbc? ( dev-db/unixODBC )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

#
# test access the network
# upstream provides no way to disable these
# tests
#
RESTRICT="test"

src_unpack() {
	# we need the -a option, so we can not use 'unpack'
	unzip -qoa "${DISTDIR}/cl${MY_PV}.zip" || die
}

wrap_python() {
	if use python; then
		cd bindings || die
		distutils-r1_${1}
	fi
}

pkg_setup() {
	#
	# Disable upstream detection
	# Non standard and hardcoded methods
	#
	export DISABLE_AUTODETECT=1

	#
	# Add our own CFLAGS/CPPFLAGS
	#
	export EXTRA_CFLAGS="${CPPFLAGS} ${CFLAGS}"

	#
	# Disable internal zlib dependnecies
	# For some reason this applied also when
	# System zlib is being used
	#
	COMMON_MAKE_OPTS="ZLIBOBJS= CC=$(tc-getCC) AR=$(tc-getAR) STRIP=true"
}

src_prepare() {
	default

	#
	# Make sure we do not use the embedded zlib
	#
	rm -fr zlib || die "remove zlib"

	#
	# Upstream package should not set optimization flags
	# Or at least allow simple method to disable behavior
	#
	sed -i -e "s:-fomit-frame-pointer::g" -e "s:-O2::g" \
		-e "s:-O3::g" -e "s:-O4::g"	makefile || die "sed makefile failed"
	sed -i -e "s/-march=[[:alnum:]\.=-]*//g" -e "s/-mcpu=[[:alnum:]\.=-]*//g" \
		-e "s:-O2::g" -e "s:-O3::g" tools/ccopts.sh || die "sed tools/ccopts.sh failed"

	#
	# Not sure  why MAKE = make is required
	# make sets this to correct value
	#
	sed -i -e "/^MAKE/d" makefile || die "sed makefile make failed"

	wrap_python ${FUNCNAME}
}

src_compile() {
	use ldap && append-cppflags -DHAS_LDAP
	use odbc && append-cppflags -DHAS_ODBC

	emake ${COMMON_MAKE_OPTS}  shared
	use static-libs && emake ${COMMON_MAKE_OPTS} default
	use test && emake ${COMMON_MAKE_OPTS} stestlib

	#
	# Symlink the libraries.
	#
	# Without this:
	# 1. python will link against the static lib
	# 2. tests will not work find soname.
	#
	# Upstream should have created the symlinks when
	# building and not when installing.
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
	emake install ${COMMON_MAKE_OPTS} DESTDIR="${D}" PREFIX=/usr PATH_LIB="/usr/$(get_libdir)"
	einstalldocs

	wrap_python ${FUNCNAME}

	if use doc; then
		newdoc "${DISTDIR}/${P}-manual.pdf" "manual.pdf"
	fi
}
