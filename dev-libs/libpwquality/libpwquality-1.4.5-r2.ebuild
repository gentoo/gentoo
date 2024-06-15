# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
inherit libtool pam distutils-r1

DESCRIPTION="Library for password quality checking and generating random passwords"
HOMEPAGE="https://github.com/libpwquality/libpwquality"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="pam python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
	python? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
	)
"
RDEPEND="
	>=sys-libs/cracklib-2.8:=[static-libs(+)?]
	pam? ( sys-libs/pam )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	elibtoolize

	if use python ; then
		cd python || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	# Install library in /lib for pam
	local myeconfargs=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable pam)
		--with-securedir="${EPREFIX}/$(getpam_mod_dir)"
		--disable-python-bindings
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"

	if use python; then
		cd python || die
		distutils-r1_src_configure
	fi
}

src_compile() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_test() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_test
	fi
}

src_install() {
	default

	if use python; then
		cd python || die
		distutils-r1_src_install
	fi

	find "${ED}" -name '*.la' -delete || die
}
