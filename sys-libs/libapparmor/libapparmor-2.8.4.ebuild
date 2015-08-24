# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
GENTOO_DEPEND_ON_PERL="no"

inherit autotools-utils distutils-r1 perl-module versionator

DESCRIPTION="Library to support AppArmor userspace utilities"
HOMEPAGE="http://apparmor.net/"
SRC_URI="https://launchpad.net/apparmor/$(get_version_component_range 1-2)/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +perl python static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-lang/perl )
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig	)"

S=${WORKDIR}/apparmor-${PV}/libraries/${PN}

src_prepare() {
	rm -r m4 || die "failed to remove bundled macros"

	autotools-utils_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with perl) \
		$(use_with python)
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile -C src

	use doc && autotools-utils_src_compile -C doc
	use perl && autotools-utils_src_compile -C swig/perl

	if use python ; then
		pushd "${BUILD_DIR}"/swig/python > /dev/null
		emake libapparmor_wrap.c
		distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	autotools-utils_src_install -C src
	use doc && autotools-utils_src_install -C doc

	if use perl ; then
		autotools-utils_src_install -C swig/perl
		perl_set_version
		insinto "${VENDOR_ARCH}"
		doins "${BUILD_DIR}"/swig/perl/LibAppArmor.pm
	fi

	if use python ; then
		pushd "${BUILD_DIR}"/swig/python > /dev/null
		distutils-r1_src_install
		popd > /dev/null
	fi
}
