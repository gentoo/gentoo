# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 xdg-utils

DESCRIPTION="A hierarchical note taking application"
HOMEPAGE="https://www.giuspen.com/cherrytree"
SRC_URI="https://github.com/giuspen/cherrytree/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pygtksourceview:2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}_update_setup_py.patch )

python_configure_all() {
	use nls || mydistutilsargs+=( --without-gettext )
}

src_install() {
	distutils-r1_src_install
	python_optimize "${D}/usr/share/${PN}/modules"

	dodoc README.md changelog.txt
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
