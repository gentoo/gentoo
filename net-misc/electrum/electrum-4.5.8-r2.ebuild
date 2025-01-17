# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 verify-sig xdg-utils

MY_P=${P^}
DESCRIPTION="User friendly Bitcoin client"
HOMEPAGE="
	https://electrum.org/
	https://github.com/spesmilo/electrum/
"
SRC_URI="
	https://download.electrum.org/${PV}/${MY_P}.tar.gz
	verify-sig? (
		https://download.electrum.org/${PV}/${MY_P}.tar.gz.asc
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli ncurses qrcode +qt5"
REQUIRED_USE="|| ( cli ncurses qt5 )"

RDEPEND="
	${PYTHON_DEPS}
	<dev-libs/libsecp256k1-0.6
	>=dev-python/aiohttp-socks-0.8.4[${PYTHON_USEDEP}]
	=dev-python/aiorpcx-0.23*[${PYTHON_USEDEP}]
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/pyperclip[${PYTHON_USEDEP}]
	dev-python/pysocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	qt5? (
		dev-python/pyqt5[gui,widgets,${PYTHON_USEDEP}]
	)
	ncurses? ( $(python_gen_impl_dep 'ncurses') )
"
BDEPEND="
	test? (
		dev-python/pyaes[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
	verify-sig? (
		sec-keys/openpgp-keys-electrum
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# test for qml/PyQt6 GUI that doesn't work anyway
	tests/test_qml_types.py
)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/electrum.asc

src_prepare() {
	distutils-r1_src_prepare

	# remove bundled dependencies
	rm -r packages || die

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

	xdg_environment_reset
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
