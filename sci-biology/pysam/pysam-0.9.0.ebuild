# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 python-r1

DESCRIPTION="Python interface for the SAM/BAM sequence alignment and mapping format"
HOMEPAGE="https://github.com/pysam-developers/pysam http://pypi.python.org/pypi/pysam"
SRC_URI="https://github.com/pysam-developers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=sci-libs/htslib-1.3*"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-missing-config.h.patch"
)

src_prepare() {
	default

	export HTSLIB_INCLUDE_DIR=${EPREFIX}/usr/include
	export HTSLIB_LIBRARY_DIR=${EPREFIX}/usr/$(get_libdir)
	export HTSLIB_CONFIGURE_OPTIONS="--disable-libcurl"

	sed -e "/ext\.extra_link_args += \['-Wl,-rpath,\$ORIGIN'\]/d" \
		-i cy_build.py || die
	sed -e '/runtime_library_dirs=htslib_library_dirs/d' \
		-i setup.py || die
}

src_compile() {
	# TODO
	# empty compile, as the build system runs the whole build again in install
	:
}
