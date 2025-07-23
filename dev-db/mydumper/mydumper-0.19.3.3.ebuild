# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )

inherit cmake python-any-r1

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"
DOCS_COMMIT="af9dcd8d9c66cf445237f9a060d07c2a4dd3d382"

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL"
HOMEPAGE="https://github.com/mydumper/mydumper"
SRC_URI="https://github.com/mydumper/mydumper/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/mydumper/mydumper_docs/archive/${DOCS_COMMIT}.tar.gz -> ${MY_P}_docs.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-arch/zstd
	dev-db/mysql-connector-c:=
	dev-libs/glib:2
	dev-libs/libpcre2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/accessible-pygments[${PYTHON_USEDEP}]
			dev-python/furo[${PYTHON_USEDEP}]
			dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
			dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.13.1-atomic.patch" #654314
	"${FILESDIR}/${PN}-0.18-Do-not-overwrite-the-user-CFLAGS.patch"
	"${FILESDIR}/${PN}-0.16-cmake-docs.patch"
)

python_check_deps() {
	python_has_version \
		"dev-python/accessible-pygments[${PYTHON_USEDEP}]" \
		"dev-python/furo[${PYTHON_USEDEP}]" \
		"dev-python/sphinx-copybutton[${PYTHON_USEDEP}]" \
		"dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]" \
		"dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# copy in docs
	rm -rv "${WORKDIR}"/"${MY_P}"/docs || die
	mv -v "${WORKDIR}/${PN}_docs-${DOCS_COMMIT}" "${WORKDIR}/${MY_P}/docs" || die

	# fix doc install path
	sed -i -e "s|share/doc/mydumper|share/doc/${PF}|" docs/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(-DBUILD_DOCS=$(usex doc))
	cmake_src_configure
}
