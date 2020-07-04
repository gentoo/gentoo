# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit cmake python-any-r1 xdg-utils

DESCRIPTION="A hierarchical note taking application (C++ version)"
HOMEPAGE="https://www.giuspen.com/cherrytree https://github.com/giuspen/cherrytree"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/giuspen/cherrytree"
	S="${WORKDIR}/${P}/future"
else
	COMMIT="074a09ce3c1130ec60f5f5a3b8be958337b6d5ab" # 20200523
	SRC_URI="https://github.com/giuspen/cherrytree/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${COMMIT}/future"
fi

# GPL-3 — future/src/ct (CherryTree)
# LGPL-2.1 — future/src/7za (7zip)
# MIT — future/src/fmt (libfmt)
LICENSE="GPL-3 LGPL-2.1 MIT"
SLOT="0"
IUSE="nls test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-text/gspell:=
	dev-libs/glib:2
	>=dev-cpp/glibmm-2.64.2:2
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0
	dev-libs/libxml2:2
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
	test? ( dev-util/cpputest )"

pkg_setup() {
	python-any-r1_pkg_setup
}

python_check_deps() {
	has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

src_prepare() {
	# disable compress man pages
	sed -i -e \
		'/install(FILES/s|${MANFILE_FULL_GZ}|${CMAKE_SOURCE_DIR}/data/cherrytree.1|' \
		CMakeLists.txt || die

	if [[ ${PV} != *9999 ]]; then
		sed -i \
			-e "/^set(CT_VERSION/s|\"\(.*\)\"|\"${PV}\"|" \
			CMakeLists.txt || die
	fi

	python_fix_shebang .
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_EXEC="${PYTHON}"
		-DUSE_NLS=$(usex nls)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
