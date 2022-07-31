# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'
inherit meson-multilib python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drobilla/sord.git"
else
	SRC_URI="http://download.drobilla.net/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Library for storing RDF data in memory"
HOMEPAGE="http://drobilla.net/software/sord/"

LICENSE="ISC"
SLOT="0"
IUSE="doc test tools"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/libpcre
	dev-libs/serd
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

src_prepare() {
	default

	# fix doc installation path
	sed -i "s/versioned_name/'${PF}'/g" doc/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_feature test tests)
		$(meson_feature tools)
	)

	meson_src_configure
}

multilib_src_test() {
	meson_src_test
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

mutlilib_src_install_all() {
	local DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}
