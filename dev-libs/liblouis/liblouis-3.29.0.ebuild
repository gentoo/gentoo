# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="https://github.com/liblouis/liblouis"
SRC_URI="https://github.com/liblouis/liblouis/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/20" # follows LIBLOUIS_CURRENT in configure.ac
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# texlive-core for patgen which is required by lou_maketable
RDEPEND="
	${PYTHON_DEPS}
	app-text/texlive-core
	test? ( dev-libs/libyaml )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${DISTUTILS_DEPS}
	${PYTHON_DEPS}
	sys-apps/help2man
"

src_prepare() {
	default

	#1. bug #913705
	#2. Use correct python version
	sed -i \
		-e "s|\$CURDIR/lou_maketable.d|${EPREFIX}/usr/libexec/lou_maketable|" \
		-e "s|python3|${EPYTHON}|" \
		tools/lou_maketable.d/lou_maketable.in || die

	pushd python > /dev/null || die
	distutils-r1_src_prepare
	popd > /dev/null || die
}

src_configure() {
	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	econf --enable-ucs4 $(use_with test yaml)
}

src_compile() {
	default

	pushd python > /dev/null || die
	# setup.py imports liblouis to get the version number,
	# and this causes the shared library to be dlopened
	# at build-time.  Hack around it with LD_PRELOAD.
	# Thanks ArchLinux.
	LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_compile
	popd > /dev/null || die
}

src_test() {
	default

	pushd python > /dev/null || die
	LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_test
	popd > /dev/null || die
}

python_test() {
	local -x LOUIS_TABLEPATH="${S}"/tables
	"${EPYTHON}" tests/test_louis.py || die
}

python_install() {
	distutils-r1_python_install
	python_scriptinto /usr/libexec/lou_maketable
	python_doexe ../tools/lou_maketable.d/*.py
}

src_install() {
	pushd python > /dev/null || die
	LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_install
	popd > /dev/null || die

	# These need to be after distutils src_install, or it'll try to install them from under python/ as well
	DOCS=( README AUTHORS NEWS ChangeLog doc/liblouis.txt )
	HTML_DOCS=( doc/liblouis.html )
	default

	# bug #913705
	mkdir -p "${ED}"/usr/libexec/lou_maketable || die
	mv "${ED}"/usr/bin/lou_maketable.d/*.{mk,pl,sh} "${ED}"/usr/libexec/lou_maketable/ || die
	rm -r "${ED}"/usr/bin/lou_maketable.d || die

	find "${ED}" -name '*.la' -delete || die
}
