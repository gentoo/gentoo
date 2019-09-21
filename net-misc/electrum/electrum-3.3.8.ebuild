# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="ncurses?"

inherit desktop distutils-r1 xdg-utils

MY_P="Electrum-${PV}"
DESCRIPTION="User friendly Bitcoin client"
HOMEPAGE="https://electrum.org/"
SRC_URI="https://download.electrum.org/${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli ncurses qrcode +qt5"

REQUIRED_USE="|| ( cli ncurses qt5 )"

RDEPEND="${PYTHON_DEPS}
	dev-python/aiohttp-socks[${PYTHON_USEDEP}]
	=dev-python/aiorpcX-0.18*[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/jsonrpclib[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/pyaes[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	qt5? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)
	ncurses? ( $(python_gen_impl_dep 'ncurses') )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply "${FILESDIR}/3.1.2-no-user-root.patch"
	eapply "${FILESDIR}/3.3.2-desktop.patch"

	# Prevent icon from being installed in the wrong location
	sed -i '/icons_dirname/d' setup.py || die

	local bestgui
	if use qt5; then
		bestgui=qt
	elif use ncurses; then
		bestgui=text
	else
		bestgui=stdio
	fi
	sed -i 's/^\([[:space:]]*\)\(config_options\['\''cwd'\''\] = .*\)$/\1\2\n\1config_options.setdefault("gui", "'"${bestgui}"'")\n/' ${PN}/${PN} || die

	eapply_user

	xdg_environment_reset
	distutils-r1_src_prepare
}

src_install() {
	doicon -s 128 electrum/gui/icons/${PN}.png
	dodoc RELEASE-NOTES
	distutils-r1_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
