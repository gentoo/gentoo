# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 desktop xdg

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#net-misc/gns3-server version should always match gns3-gui version
RDEPEND="
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/jsonschema-3.2.0:=[${PYTHON_USEDEP}]' 'python3_8')
	$(python_gen_cond_dep '<=dev-python/jsonschema-2.6.0:=[${PYTHON_USEDEP}]' 'python3_7')
	>=dev-python/psutil-5.6.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.14.4[${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
"

DISTUTILS_USE_SETUPTOOLS=bdepend

PATCHES=( "${FILESDIR}/gns3-gui-rmraven.patch" )

src_prepare() {
	default
	# newer psutils is fine
	sed -i -e '/psutil==5.6.6/d' requirements.txt || die "fixing requirements failed"
	eapply_user
}

python_install_all() {
	distutils-r1_python_install_all

	doicon "resources/images/gns3.ico"
	make_desktop_entry "gns3" "GNS3" "gns3.ico" "Utility"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
