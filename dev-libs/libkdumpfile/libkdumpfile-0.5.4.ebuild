# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools python-r1

DESCRIPTION="Kernel coredump file access"
HOMEPAGE="https://github.com/ptesarik/libkdumpfile"
SRC_URI="https://github.com/ptesarik/libkdumpfile/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="|| ( LGPL-3+ GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="lzo snappy zlib zstd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy:= )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-c99.patch
	"${FILESDIR}"/${P}-disabled-compression-tests.patch
	"${FILESDIR}"/${P}-32-bit-tests.patch
)

src_prepare() {
	default

	# Can drop on next release >0.5.4
	eautoreconf
}

src_configure() {
	# We could make Python optional in future as libkdumpfile's
	# builtin Python bindings appear deprecated in favour of another
	# CFFI-based approach, but given we're adding libkdumpfile for
	# dev-debug/drgn right now which uses *these*, let's not bother.
	local ECONF_SOURCE=${S}
	local myeconfargs=(
		$(use_with lzo lzo2)
		$(use_with snappy)
		$(use_with zlib)
		$(use_with zstd libzstd)
	)

	python_foreach_impl run_in_build_dir econf "${myeconfargs[@]}"
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	python_foreach_impl python_optimize
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
