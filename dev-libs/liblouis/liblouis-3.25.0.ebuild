# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_OPTIONAL=1
inherit distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="https://github.com/liblouis/liblouis"
SRC_URI="https://github.com/liblouis/liblouis/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/20"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	python? ( ${PYTHON_DEPS}
		>=dev-python/setuptools-42.0.2[${PYTHON_USEDEP}]
	)
	test? ( dev-libs/libyaml )
"

src_prepare() {
	default

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	# CONFIG_SHELL is temporary until https://github.com/liblouis/liblouis/pull/1369
	# is in a release.
	CONFIG_SHELL="${BROOT}"/bin/bash econf --enable-ucs4
}

src_compile() {
	default

	if use python; then
		pushd python > /dev/null || die
		# setup.py imports liblouis to get the version number,
		# and this causes the shared library to be dlopened
		# at build-time.  Hack around it with LD_PRELOAD.
		# Thanks ArchLinux.
		LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_test() {
	default

	if use python; then
		pushd python > /dev/null || die
		LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_test
		popd > /dev/null || die
	fi
}

python_test() {
	local -x LOUIS_TABLEPATH="${S}"/tables
	"${EPYTHON}" tests/test_louis.py || die
}

src_install() {
	if use python; then
		pushd python > /dev/null || die
		LD_PRELOAD+=":${S}/liblouis/.libs/liblouis.so" distutils-r1_src_install
		popd > /dev/null || die
	fi

	# These need to be after distutils src_install, or it'll try to install them from under python/ as well
	DOCS=( README AUTHORS NEWS ChangeLog doc/liblouis.txt )
	HTML_DOCS=( doc/liblouis.html )
	default

	find "${ED}" -name '*.la' -delete || die
}
