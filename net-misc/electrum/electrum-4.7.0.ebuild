# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 eapi9-ver verify-sig xdg-utils

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
IUSE="cli ncurses qrcode +qt6"
REQUIRED_USE="|| ( cli ncurses qt6 )"

# setuptools (distutils) & pyperclip vendored
RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/aiohttp-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-socks-0.8.4[${PYTHON_USEDEP}]
	=dev-python/aiorpcx-0.25*[${PYTHON_USEDEP}]
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2[${PYTHON_USEDEP}]
	>=dev-python/electrum-ecc-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/electrum-aionostr-0.1.0[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20[${PYTHON_USEDEP}]
	dev-python/pyperclip[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	qt6? (
		dev-python/pyqt6[gui,multimedia,printsupport,qml,quick,widgets,${PYTHON_USEDEP}]
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

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/electrum.asc

src_prepare() {
	distutils-r1_src_prepare

	# remove bundled dependencies
	rm -r electrum/_vendor packages || die
	find -name '*.py' -exec \
		sed -i -e 's:\(electrum\)\?[.]_vendor[.]::' {} + || die

	# use backwards-compatible cryptodome API
	sed -i -e 's:Cryptodome:Crypto:' electrum/crypto.py || die

	# make qdarkstyle dep optional
	sed -i -e '/qdarkstyle/d' contrib/requirements/requirements.txt || die

	# remove upper bounds from deps
	sed -i -e 's:,<[0-9.]*::' contrib/requirements/requirements.txt || die

	local bestgui
	if use qt6; then
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

	ver_replacing -ge 4.3.4 && return

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
