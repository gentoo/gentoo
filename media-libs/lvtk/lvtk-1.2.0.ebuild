# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
inherit python-single-r1 waf-utils

DESCRIPTION="A set of C++ wrappers around the LV2 C API"
HOMEPAGE="http://lvtoolkit.org/"
SRC_URI="https://github.com/lvtk/lvtk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples +gtk2 +tools"

RDEPEND="media-libs/lv2
	>=dev-libs/boost-1.40.0
	gtk2? ( dev-cpp/gtkmm:2.4 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen
		media-gfx/graphviz )
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
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

	# It does not respect docdir properly, reported upstream
	if use doc; then
		mv "${ED}/usr/share/doc/${PF}/lvtk-1.0/html" "${ED}/usr/share/doc/${PF}/html"
		rmdir "${ED}/usr/share/doc/${PF}/lvtk-1.0"
	fi
}
