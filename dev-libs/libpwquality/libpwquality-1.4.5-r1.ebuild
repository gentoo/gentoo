# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit libtool pam python-r1

DESCRIPTION="Library for password quality checking and generating random passwords"
HOMEPAGE="https://github.com/libpwquality/libpwquality"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="pam python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
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
		# bug #830397
		export SETUPTOOLS_USE_DISTUTILS=stdlib
		python_copy_sources
	fi
}

src_configure() {
	# Install library in /lib for pam
	configuring() {
		local sitedir
		econf \
			--libdir="${EPREFIX}/usr/$(get_libdir)" \
			$(use_enable pam) \
			--with-securedir="${EPREFIX}/$(getpam_mod_dir)" \
			$(use_enable python python-bindings) \
			$(usex python "--with-pythonsitedir=$(use python && python_get_sitedir)" "") \
			$(use_enable static-libs static)
	}
	if_use_python_python_foreach_impl configuring
}

src_compile() {
	if_use_python_python_foreach_impl default
}

src_test() {
	if_use_python_python_foreach_impl default
}

src_install() {
	if_use_python_python_foreach_impl default
	find "${ED}" -name '*.la' -delete || die
}

if_use_python_python_foreach_impl() {
	if use python; then
		python_foreach_impl run_in_build_dir "$@"
	else
		"$@"
	fi
}
