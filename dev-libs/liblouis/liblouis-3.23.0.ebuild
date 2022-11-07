# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_OPTIONAL=1
inherit distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="https://github.com/liblouis/liblouis"
SRC_URI="https://github.com/liblouis/liblouis/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/20"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/help2man
	python? ( ${PYTHON_DEPS}
		>=dev-python/setuptools-42.0.2[${PYTHON_USEDEP}]
	)
	test? ( dev-libs/libyaml )
"

src_prepare() {
	default

	if use python; then
		pushd python > /dev/null
		distutils-r1_src_prepare
		popd > /dev/null
	fi
}

src_configure() {
	econf \
		--enable-ucs4 \
		--disable-static
}

src_compile() {
	default

	if use python; then
		pushd python > /dev/null
		# setup.py imports liblouis to get the version number,
		# and this causes the shared library to be dlopened
		# at build-time.  Hack around it with LD_PRELOAD.
		# Thanks ArchLinux.
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so'
			distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	if use python; then
		pushd python > /dev/null
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so' \
			distutils-r1_src_install
		popd > /dev/null
	fi

	# These need to be after distutils src_install, or it'll try to install them from under python/ as well
	DOCS=( README AUTHORS NEWS ChangeLog doc/liblouis.txt )
	HTML_DOCS=( doc/liblouis.html )
	default

	find "${ED}" -name '*.la' -delete || die
}
