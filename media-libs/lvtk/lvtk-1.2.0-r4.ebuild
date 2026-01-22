# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit dot-a python-any-r1 waf-utils

WAF_VER=2.0.20

DESCRIPTION="A set of C++ wrappers around the LV2 C API"
HOMEPAGE="https://lvtk.org/"
SRC_URI="https://github.com/lvtk/lvtk/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://waf.io/waf-${WAF_VER}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc examples +gtk2 +tools"

RDEPEND="
	media-libs/lv2
	dev-libs/boost
	gtk2? ( dev-cpp/gtkmm:2.4 )
"
DEPEND="
	${RDEPEND}
	doc? ( app-text/doxygen
		media-gfx/graphviz )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-py3.patch"
)

src_unpack() {
	unpack ${P}.tar.gz || die

	# we need newer version of waf to work with py3
	cp "${DISTDIR}/waf-${WAF_VER}" "${S}/waf" || die
}

src_configure() {
	lto-guarantee-fat

	local mywafconfargs=(
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
		"--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2"
	)
	use debug    && mywafconfargs+=( "--debug" )
	use doc      && mywafconfargs+=( "--docs" )
	use examples || mywafconfargs+=( "--disable-examples" )
	use tools    || mywafconfargs+=( "--disable-tools" )
	use gtk2     || mywafconfargs+=( "--disable-ui" )
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	waf-utils_src_install

	strip-lto-bytecode

	# It does not respect docdir properly, reported upstream
	if use doc; then
		mv "${ED}/usr/share/doc/${PF}/lvtk-1/html" "${ED}/usr/share/doc/${PF}/html" || die
		rmdir "${ED}/usr/share/doc/${PF}/lvtk-1" || die
	fi
}
