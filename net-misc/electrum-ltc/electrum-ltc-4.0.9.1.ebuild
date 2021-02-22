# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_8 )
PYTHON_REQ_USE="ncurses?"

inherit desktop distutils-r1 gnome2-utils xdg-utils

EGIT_COMMIT="${PV}"
DESCRIPTION="Litecoin thin client"
HOMEPAGE="https://electrum-ltc.org/"
SRC_URI="https://github.com/pooler/electrum-ltc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="audio_modem cli cosign digitalbitbox email ncurses qrcode +qt5 sync vkb
	l10n_es l10n_ja l10n_pt-BR l10n_pt-PT l10n_zh-CN"

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

RDEPEND="${PYTHON_DEPS}
	dev-python/aiohttp-socks[${PYTHON_USEDEP}]
	=dev-python/aiorpcX-0.19*[${PYTHON_USEDEP}]
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
	ncurses? ( dev-lang/python )
"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DOCS="RELEASE-NOTES"

src_prepare() {
	eapply "${FILESDIR}/3.1.2-no-user-root.patch"
	eapply "${FILESDIR}/3.2.3-pip-optional-pkgs.patch"
	eapply "${FILESDIR}/3.3.2-desktop.patch"

	# unbind aiorpcX dep
	sed -e '/aiorpcx/s:,<0.19::' \
		-i contrib/requirements/requirements.txt || die

	# Prevent icon from being installed in the wrong location
	sed -i '/icons_dirname/d' setup.py || die

	if ! use qt5; then
		sed "/'electrum_ltc.gui.qt',/d" -i setup.py || die
	fi

	local wordlist=
	for wordlist in  \
		$(usex l10n_ja    '' japanese) \
		$(usex l10n_pt-BR '' $(usex l10n_pt-PT '' portuguese)) \
		$(usex l10n_es    '' spanish) \
		$(usex l10n_zh-CN '' chinese_simplified) \
	; do
		rm -f "${PN}/wordlist/${wordlist}.txt" || die
		sed -i "/${wordlist}\\.txt/d" ${PN/-/_}/mnemonic.py || die
	done

	# Remove unrequested GUI implementations:
	local gui setup_py_gui
	for gui in  \
		$(usex cli      '' stdio)  \
		kivy \
		$(usex qt5      '' qt   )  \
		$(usex ncurses  '' text )  \
	; do
		rm ${PN/-/_}/gui/"${gui}"* -r || die
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
	sed -i 's/^\([[:space:]]*\)\(config_options\['\''cwd'\''\] = .*\)$/\1\2\n\1config_options.setdefault("gui", "'"${bestgui}"'")\n/' ${PN/-/_}/${PN} || die

	local plugin
	# trezor requires python trezorlib module
	# keepkey requires trezor
	for plugin in  \
		$(usex audio_modem     '' audio_modem          ) \
		$(usex cosign          '' cosigner_pool        ) \
		$(usex digitalbitbox   '' digitalbitbox        ) \
		$(usex email           '' email_requests       ) \
		ledger \
		keepkey \
		$(usex sync            '' labels               ) \
		trezor  \
		$(usex vkb             '' virtualkeyboard      ) \
	; do
		rm -r ${PN/-/_}/plugins/"${plugin}"* || die
		sed -i "/${plugin}/d" setup.py || die
	done

	eapply_user

	xdg_environment_reset
	distutils-r1_src_prepare
}

src_install() {
	doicon -s 128 ${PN/-/_}/gui/icons/${PN}.png
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
