# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit autotools python-r1 toolchain-funcs

DESCRIPTION="Satyr is a collection of low-level algorithms for program failure processing"
HOMEPAGE="https://github.com/abrt/satyr"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/3"

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

KEYWORDS="amd64 x86"

RDEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/elfutils-0.158
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	./gen-version || die # Needs to be run before full autoreconf
	eautoreconf
	use python && python_copy_sources
}

src_configure() {
	local myargs=(
		--localstatedir="${EPREFIX}/var"
		--without-rpm
		# Build breaks without and we aren't supporting Python2 anyway
		--without-python2
		$(usex python "--with-python3" "--without-python3")
	)

	econf "${myargs[@]}"
}
