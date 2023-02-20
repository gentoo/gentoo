# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg

MY_PN="DisplayCAL"
MY_P="${MY_PN}-${PV}"

SRC_URI="https://github.com/eoyilmaz/displaycal-py3/releases/download/${PV}/${MY_P}.tar.gz"
KEYWORDS="~amd64"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Modernize the DisplayCAL code including Python 3 support"
HOMEPAGE="https://github.com/eoyilmaz/displaycal-py3"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND="
	dev-python/build[${PYTHON_USEDEP}]
	dev-python/certifi:0[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pychromecast[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	dev-python/zeroconf[${PYTHON_USEDEP}]
	>=dev-python/wxpython-4.2.0[${PYTHON_USEDEP}]
	media-gfx/argyllcms
	x11-libs/libXxf86vm"

RDEPEND="${DEPEND}"

src_prepare() {
	# Fix QA warning
	sed -e 's/license_file/license_files/g' -i setup.cfg || die

	# Remove x-world MIME
	sed -i 's|x-world/x-vrml;||g' \
		misc/displaycal-vrml-to-x3d-converter.desktop || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	# Use Gentoo package name for doc folder
	mv "${ED}/usr/share/doc/${MY_P}" "${ED}/usr/share/doc/${P}" || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
