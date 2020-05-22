# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit cmake desktop python-single-r1 xdg

MY_PN=Cura

DESCRIPTION="A 3D model slicing application for 3D printing"
HOMEPAGE="https://github.com/Ultimaker/Cura"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+usb zeroconf"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="sys-devel/gettext"
RDEPEND="${PYTHON_DEPS}
	>=dev-libs/libcharon-${PV:0:3}[${PYTHON_SINGLE_USEDEP}]
	>=dev-libs/libsavitar-${PV:0:3}:=[python,${PYTHON_SINGLE_USEDEP}]
	>=dev-python/uranium-${PV:0:3}[${PYTHON_SINGLE_USEDEP}]
	>=media-gfx/curaengine-${PV:0:3}
	>=media-gfx/fdm-materials-${PV:0:3}
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_MULTI_USEDEP}]
		usb? ( dev-python/pyserial[${PYTHON_MULTI_USEDEP}] )
		zeroconf? ( dev-python/zeroconf[${PYTHON_MULTI_USEDEP}] )
	')"
DEPEND="${RDEPEND}"

DOCS=( README.md )
PATCHES=( "${FILESDIR}/${PN}-4.6.1-fix-install-paths.patch" )
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	sed -i "s/set(CURA_VERSION \"master\"/set(CURA_VERSION \"${PV}\"/" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doicon icons/*.png
	python_optimize "${D}${get_libdir}"
}
