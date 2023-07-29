# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 xdg-utils

DESCRIPTION="User friendly Bitcoin client"
HOMEPAGE="
	https://electrum.org/
	https://github.com/spesmilo/electrum/
"
SRC_URI="
	https://github.com/spesmilo/electrum/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli ncurses qrcode +qt5"
REQUIRED_USE="|| ( cli ncurses qt5 )"

RDEPEND="
	${PYTHON_DEPS}
	<dev-libs/libsecp256k1-0.4
	>=dev-python/aiohttp-socks-0.3[${PYTHON_USEDEP}]
	=dev-python/aiorpcX-0.22*[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/bitstring[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/pyperclip[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.20[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	qt5? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)
	ncurses? ( $(python_gen_impl_dep 'ncurses') )
"
BDEPEND="
	test? (
		dev-python/pyaes[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# use backwards-compatible cryptodome API
	sed -i -e 's:Cryptodome:Crypto:' electrum/crypto.py || die

	# make qdarkstyle dep optional
	sed -i -e '/qdarkstyle/d' contrib/requirements/requirements.txt || die

	# remove upper bounds from deps
	sed -i -e 's:,<[0-9.]*::' contrib/requirements/requirements.txt || die

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
	dodoc RELEASE-NOTES
	distutils-r1_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	local v
	for v in ${REPLACING_VERSIONS}; do
		ver_test "${v}" -ge 4.3.4 && return
	done

	ewarn "If you are new to BitCoin, please be aware that:"
	ewarn "1. Cryptocurrencies are volatile.  BTC has been subject to rapid"
	ewarn "   changes of value in the past."
	ewarn "2. Cryptocurrency ownership is determined solely by the access to"
	ewarn "   the private key.  If the key is lost or stolen, BTC are unrevocably"
	ewarn "   lost."
	ewarn "3. Proof-of-work based cryptocurrencies have negative environmental"
	ewarn "   impact.  BTC mining is consuming huge amounts of electricity."
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
