# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{5,6,7,8} )
GENTOO_DEPEND_ON_PERL="no"

inherit autotools distutils-r1 perl-functions

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Library to support AppArmor userspace utilities"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="https://launchpad.net/apparmor/${MY_PV}/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
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

PATCHES=( "${FILESDIR}/${PN}-2.10-symbol_visibility.patch" )

# depends on the package already being installed
RESTRICT="test"

src_prepare() {
	rm -r m4 || die "failed to remove bundled macros"
	default
	eautoreconf
	use python && distutils-r1_src_prepare
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with perl) \
		$(use_with python)
}

src_compile() {
	emake -C src
	emake -C include
	use doc && emake -C doc
	use perl && emake -C swig/perl

	if use python ; then
		pushd swig/python > /dev/null
		emake libapparmor_wrap.c
		distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	emake DESTDIR="${D}" -C src install
	emake DESTDIR="${D}" -C include install
	use doc && emake DESTDIR="${D}" -C doc install

	if use perl ; then
		emake DESTDIR="${D}" -C swig/perl install
		perl_set_version
		insinto "${VENDOR_ARCH}"
		doins swig/perl/LibAppArmor.pm

		# bug 620886
		perl_delete_localpod
		perl_fix_packlist
	fi

	if use python ; then
		pushd swig/python > /dev/null
		distutils-r1_src_install

		python_moduleinto LibAppArmor
		python_foreach_impl python_domodule LibAppArmor.py
		popd > /dev/null
	fi

	dodoc AUTHORS ChangeLog NEWS README

	find "${D}" -name '*.la' -delete || die
}
