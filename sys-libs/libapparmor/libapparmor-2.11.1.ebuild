# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
GENTOO_DEPEND_ON_PERL="no"

inherit autotools-utils distutils-r1 perl-functions versionator

MY_PV="$(get_version_component_range 1-2)"

DESCRIPTION="Library to support AppArmor userspace utilities"
HOMEPAGE="http://apparmor.net/"
SRC_URI="https://launchpad.net/apparmor/${MY_PV}/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +perl +python static-libs"

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

RESTRICT="test"

src_prepare() {
	rm -r m4 || die "failed to remove bundled macros"
	epatch "${FILESDIR}"/${PN}-2.10-symbol_visibility.patch
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
	autotools-utils_src_compile -C include
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
	autotools-utils_src_install -C include
	use doc && autotools-utils_src_install -C doc

	if use perl ; then
		autotools-utils_src_install -C swig/perl
		perl_set_version
		insinto "${VENDOR_ARCH}"
		doins "${BUILD_DIR}"/swig/perl/LibAppArmor.pm

		# bug 620886
		perl_delete_localpod
		perl_fix_packlist
	fi

	if use python ; then
		pushd "${BUILD_DIR}"/swig/python > /dev/null
		distutils-r1_src_install

		python_moduleinto LibAppArmor
		python_foreach_impl python_domodule LibAppArmor.py
		popd > /dev/null
	fi
}
