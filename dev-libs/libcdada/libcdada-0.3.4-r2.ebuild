# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_9 )
inherit autotools python-any-r1

DESCRIPTION="Basic data structures in C"
HOMEPAGE="https://github.com/msune/libcdada"
SRC_URI="https://github.com/msune/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=( "${FILESDIR}/${PN}-${PV}-Werror.patch" )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	if ! use test; then
		sed -ie "/SUBDIRS/s/test //" Makefile.am || die
	fi
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-valgrind
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
