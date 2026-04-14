# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit autotools distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="https://github.com/liblouis/liblouis"
SRC_URI="https://github.com/liblouis/liblouis/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+ tools? ( GPL-3+ )"
SLOT="0/21" # follows LIBLOUIS_CURRENT in configure.ac
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test tools"
REQUIRED_USE="
	test? ( tools )
	tools? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

# texlive-core for patgen which is required by lou_maketable; and makeinfo for .info
# make tools optional to avoid texlive-core
RDEPEND="
	test? (
		${PYTHON_DEPS}
		dev-libs/libyaml
	)
	tools? ( app-text/texlive-core )
"
DEPEND="${RDEPEND}"
BDEPEND="
	tools? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
		sys-apps/help2man
	)
"

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

src_prepare() {
	default

	if use tools; then
		#1. bug #913705
		#2. Use correct python version
		sed -i \
			-e "s|\$CURDIR/lou_maketable.d|${EPREFIX}/usr/libexec/lou_maketable|" \
			-e "s|python3|${EPYTHON}|" \
			tools/lou_maketable.d/lou_maketable.in || die

		pushd python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	else
		sed -i '/^SUBDIRS =/s/tools//' Makefile.am || die
		eautoreconf
	fi
}

src_configure() {
	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	# bash shebang, source in python/louis/Makefile.am, bash in tools/lou_maketable.d/lou_maketable.mk
	export CONFIG_SHELL=${BASH}

	use tools || export ac_cv_prog_HELP2MAN=

	econf --enable-ucs4 $(use_with test yaml)
}

src_compile() {
	default

	if use tools; then
		pushd python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_test() {
	default

	if use tools; then
		pushd python > /dev/null || die
		LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_test
		popd > /dev/null || die
	fi
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
	if use tools; then
		pushd python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi

	# These need to be after distutils src_install, or it'll try to install them from under python/ as well
	default

	if use tools; then
		# bug #913705
		mkdir -p "${ED}"/usr/libexec/lou_maketable || die
		mv "${ED}"/usr/bin/lou_maketable.d/*.{mk,pl,sh} "${ED}"/usr/libexec/lou_maketable/ || die
		rm -r "${ED}"/usr/bin/lou_maketable.d || die
	fi

	find "${ED}" -name '*.la' -delete || die
}
