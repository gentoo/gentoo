# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

WSLAY_HASH="45d22583b488f79d5a4e598cc7675c191c5ab53f"

DESCRIPTION="WebSocket library in C"
HOMEPAGE="https://tatsuhiro-t.github.io/wslay/"
SRC_URI="https://github.com/tatsuhiro-t/wslay/archive/${WSLAY_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${WSLAY_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-util/cunit )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"

src_prepare() {
	default

	# skip unnecessary examples & automagic dependency on nettle
	sed -i '/build_examples=/s/yes/no/' configure.ac || die

	eautoreconf
}

src_configure() {
	local econfargs=(
		# no options... and cmake build has different issues
		$(usev !doc ac_cv_path_SPHINX_BUILD=)
		$(usev !test ac_cv_lib_cunit_CU_initialize_registry=)
	)

	econf "${econfargs[@]}"
}

src_compile() {
	emake $(usev doc -j1) #921192
}

src_install() {
	local DOCS=( AUTHORS NEWS README.rst ) # skip non-rst README
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
