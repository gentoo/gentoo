# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 gnome2-utils xdg-utils

EGIT_COMMIT="d088f561b2875b4cda0689f9e9d911d558711e15"
DESCRIPTION="Litecoin thin client"
HOMEPAGE="https://electrum-ltc.org/"
SRC_URI="https://github.com/pooler/electrum-ltc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/spesmilo/electrum/compare/a4e89e822a208daa574c4bd1d8ecfea952c6c101...b4e43754e0f60d8438b5fd412de816a466344401.patch -> ${P}-electrum-3.0.3.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LINGUAS="es_ES ja_JP pt_BR pt_PT zh_CN"

IUSE="audio_modem cli cosign digitalbitbox email ncurses qrcode +qt5 sync vkb"

for lingua in ${LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done

REQUIRED_USE="
	|| ( cli ncurses qt5 )
	audio_modem? ( qt5 )
	cosign? ( qt5 )
	digitalbitbox? ( qt5 )
	email? ( qt5 )
	qrcode? ( qt5 )
	sync? ( qt5 )
	vkb? ( qt5 )
"

RDEPEND="
	dev-python/scrypt[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/jsonrpclib[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/pyaes[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tlslite[${PYTHON_USEDEP}]
	|| (
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-libs/protobuf[python,${PYTHON_USEDEP}]
	)
	virtual/python-dnspython[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	qt5? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)
	ncurses? ( dev-lang/python )
"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DOCS=( RELEASE-NOTES )

src_prepare() {
	# include the last changes that apply from electrum 3.0.3
	eapply <(sed -e '73,92d' "${DISTDIR}/${P}-electrum-3.0.3.patch")
	eapply "${FILESDIR}/2.8.0-no-user-root.patch"

	# Prevent icon from being installed in the wrong location
	sed -i '/icons/d' setup.py || die

	pyrcc5 icons.qrc -o gui/qt/icons_rc.py || die

	local wordlist=
	for wordlist in  \
		$(usex linguas_ja_JP '' japanese) \
		$(usex linguas_pt_BR '' $(usex linguas_pt_PT '' portuguese)) \
		$(usex linguas_es_ES '' spanish) \
		$(usex linguas_zh_CN '' chinese_simplified) \
	; do
		rm -f "lib/wordlist/${wordlist}.txt" || die
		sed -i "/${wordlist}\\.txt/d" lib/mnemonic.py || die
	done

	# Remove unrequested GUI implementations:
	local gui setup_py_gui
	for gui in  \
		$(usex cli      '' stdio)  \
		kivy \
		$(usex qt5      '' qt   )  \
		$(usex ncurses  '' text )  \
	; do
		rm gui/"${gui}"* -r || die
	done

	# And install requested ones...
	for gui in  \
		$(usex qt5      qt   '')  \
	; do
		setup_py_gui="${setup_py_gui}'electrum_gui.${gui}',"
	done

	sed -i "s/'electrum_gui\\.qt',/${setup_py_gui}/" setup.py || die

	local bestgui
	if use qt5; then
		bestgui=qt
	elif use ncurses; then
		bestgui=text
	else
		bestgui=stdio
	fi
	sed -i 's/^\([[:space:]]*\)\(config_options\['\''cwd'\''\] = .*\)$/\1\2\n\1config_options.setdefault("gui", "'"${bestgui}"'")\n/' electrum-ltc || die

	local plugin
	# trezor requires python trezorlib module
	# keepkey requires trezor
	for plugin in  \
		$(usex audio_modem     '' audio_modem          ) \
		$(usex cosign          '' cosigner_pool        ) \
		$(usex digitalbitbox   '' digitalbitbox        ) \
		$(usex email           '' email_requests       ) \
		hw_wallet \
		ledger \
		keepkey \
		$(usex sync            '' labels               ) \
		trezor  \
		$(usex vkb             '' virtualkeyboard      ) \
	; do
		rm -r plugins/"${plugin}"* || die
		sed -i "/${plugin}/d" setup.py || die
	done

	eapply_user

	distutils-r1_src_prepare
}

src_install() {
	doicon -s 128 icons/${PN}.png
	distutils-r1_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
