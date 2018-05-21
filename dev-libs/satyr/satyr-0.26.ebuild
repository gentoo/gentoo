# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit autotools ltprune python-r1 toolchain-funcs

DESCRIPTION="Satyr is a collection of low-level algorithms for program failure processing"
HOMEPAGE="https://github.com/abrt/satyr"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.158
"
DEPEND="${RDEPEND}
	dev-python/sphinx
	virtual/pkgconfig
"

src_prepare() {
	default
	./gen-version || die # Needs to be run before full autoreconf
	eautoreconf
	python_copy_sources
}

src_configure() {
	local myargs=(
		--localstatedir="${EPREFIX}/var" \
		# Build breaks without and we aren't supporting Python2 anyway
		--without-python2
	)

	python_foreach_impl run_in_build_dir \
		econf "${myargs[@]}"
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	prune_libtool_files --modules
}
