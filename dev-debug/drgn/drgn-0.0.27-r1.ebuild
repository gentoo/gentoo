# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit autotools distutils-r1 multiprocessing pypi toolchain-funcs

DESCRIPTION="Programmable debugger"
HOMEPAGE="
	https://github.com/osandov/drgn
	https://pypi.org/project/drgn/
	https://drgn.readthedocs.io/en/latest/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

DEPEND="
	>=dev-libs/elfutils-0.165
	dev-libs/libkdumpfile
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.27-bashism.patch
)

distutils_enable_tests unittest

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	distutils-r1_src_prepare

	cd libdrgn || die
	eautoreconf
}

src_configure() {
	tc-export AR CC OBJCOPY OBJDUMP PKG_CONFIG RANLIB STRIP

	cat >> setup.cfg <<-EOF || die
	[build_ext]
	parallel = $(makeopts_jobs)
	EOF

	# setuptools calls autotools (!)
	export CONFIGURE_FLAGS
	CONFIGURE_FLAGS="--disable-dependency-tracking --disable-silent-rules"
	CONFIGURE_FLAGS+=" --with-libkdumpfile"
	CONFIGURE_FLAGS+=" $(use_enable openmp)"
	distutils-r1_src_configure
}
