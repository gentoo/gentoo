# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
GENTOO_DEPEND_ON_PERL="no"

inherit autotools distutils-r1 dot-a perl-module

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Library to support AppArmor userspace utilities"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="https://launchpad.net/apparmor/${MY_PV}/${PV}/+download/apparmor-${PV}.tar.gz"
S=${WORKDIR}/apparmor-${PV}/libraries/${PN}

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="doc +perl +python ${GENTOO_PERL_USESTRING} test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
	python? (
		${PYTHON_DEPS}
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	sys-apps/which
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-lang/perl )
	perl? ( dev-lang/swig )
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		dev-lang/swig
	)
	test? (
		dev-util/dejagnu
	)
"

src_prepare() {
	default

	use python && distutils-r1_src_prepare

	# We used to rm m4/ but led to this after eautoreconf:
	# checking whether the libapparmor man pages should be generated... yes
	# ./configure: 5065: PROG_PODCHECKER: not found
	# ./configure: 5068: PROG_POD2MAN: not found
	# checking whether python bindings are enabled... yes
	eautoreconf
}

src_configure() {
	lto-guarantee-fat

	# Run configure through distutils-r1.eclass. Bug 764779
	if use python; then
		distutils-r1_src_configure
	else
		python_configure_all
	fi
}

python_configure_all() {
	# Fails with reflex/byacc, heavily relies on bisonisms
	export LEX=flex
	export YACC=yacc.bison

	local myeconfargs=(
		# Needed for tests, just always install them.
		--enable-static
		$(use_with perl)
		$(use_with python)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C src
	emake -C include
	use doc && emake -C doc
	use perl && emake -C swig/perl

	if use python ; then
		pushd swig/python > /dev/null || die
		emake libapparmor_wrap.c
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_test() {
	# Avoid perl-module_src_test. We also need to avoid running the
	# Python tests in the wrong environment here.
	mv swig/python/test/test_python.py.in{,.bak} || die
	touch swig/python/test/test_python.py.in
	default
	mv swig/python/test/test_python.py.in{.bak,} || die

	if use python ; then
		pushd swig/python > /dev/null || die
		distutils-r1_src_test
		popd > /dev/null || die
	fi
}

python_test() {
	cd test || die

	# Force regeneration wrt the earlier hack we did
	touch test_python.py.in || die
	# Create test_python.py from test_python.py.in
	emake test_python.py

	LD_LIBRARY_PATH="${S}/src/.libs:${LD_LIBRARY_PATH}" ${EPYTHON} test_python.py || die
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
		pushd swig/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi

	dodoc AUTHORS ChangeLog NEWS README

	strip-lto-bytecode
	find "${D}" -name '*.la' -delete || die
}

python_install() {
	distutils-r1_python_install

	python_moduleinto LibAppArmor
	python_domodule LibAppArmor.py
}
