# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
inherit autotools distutils-r1

DESCRIPTION="Simplified, portable interface to several low-level networking routines"
HOMEPAGE="https://github.com/ofalk/libdnet"
SRC_URI="https://github.com/ofalk/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-libs/libbsd
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"
BDEPEND="
	python? ( dev-python/cython[${PYTHON_USEDEP}] )
	test? ( dev-libs/check )
"

DOCS=( README.md THANKS )

src_prepare() {
	default

	sed -i \
		-e 's/libcheck.a/libcheck.so/g' \
		configure.ac || die
	sed -i \
		-e "s/lib\/libcheck/$(get_libdir)\/libcheck/g" \
		configure.ac || die
	sed -i \
		-e 's|-L$libdir ||g' \
		dnet-config.in || die
	sed -i \
		-e '/^SUBDIRS/s|python||g' \
		Makefile.am || die

	# Stale e.g. pkg-config macros w/ bashisms
	rm aclocal.m4 {config,m4}/libtool.m4 || die

	AT_M4DIR="config" eautoreconf

	if use python; then
		cd python || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	econf \
		$(use_with python) \
		$(use_enable test check)
}

src_compile() {
	default

	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_test() {
	# https://bugs.gentoo.org/778797#c4
	# check_ip needs privileges and check_fw can't work on Linux
	emake check XFAIL_TESTS="check_fw check_ip"
}

src_install() {
	default

	if use python; then
		cd python || die
		unset DOCS
		distutils-r1_src_install
	fi

	find "${ED}" -name '*.la' -delete || die
}
