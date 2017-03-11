# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 gnome2-utils

MY_P="Electrum-${PV}"
DESCRIPTION="User friendly Bitcoin client"
HOMEPAGE="https://electrum.org/"
SRC_URI="https://download.electrum.org/${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LINGUAS="ar_SA bg_BG cs_CZ da_DK de_DE el_GR eo_UY es_ES fr_FR hu_HU hy_AM id_ID it_IT ja_JP ko_KR ky_KG lv_LV nb_NO nl_NL no_NO pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK sl_SI ta_IN th_TH tr_TR vi_VN zh_CN"

IUSE="audio_modem cli cosign digitalbitbox email greenaddress_it ncurses qrcode +qt4 sync trustedcoin_com vkb"

for lingua in ${LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done

REQUIRED_USE="
	|| ( cli ncurses qt4 )
	audio_modem? ( qt4 )
	cosign? ( qt4 )
	digitalbitbox? ( qt4 )
	email? ( qt4 )
	greenaddress_it? ( qt4 )
	qrcode? ( qt4 )
	sync? ( qt4 )
	trustedcoin_com? ( qt4 )
	vkb? ( qt4 )
"

RDEPEND="
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/jsonrpclib[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/slowaes[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tlslite[${PYTHON_USEDEP}]
	dev-libs/protobuf[python,${PYTHON_USEDEP}]
	virtual/python-dnspython[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[python,v4l,${PYTHON_USEDEP}] )
	qt4? (
		dev-python/PyQt4[X,${PYTHON_USEDEP}]
	)
	ncurses? ( dev-lang/python )
"

S="${WORKDIR}/${MY_P}"

DOCS="RELEASE-NOTES"

src_prepare() {
	eapply "${FILESDIR}/${PV}-no-user-root.patch"

	# Don't advise using PIP
	sed -i "s/On Linux, try 'sudo pip install zbar'/Re-emerge Electrum with the qrcode USE flag/" lib/qrscanner.py || die

	# Prevent icon from being installed in the wrong location
	sed -i '/icons/d' setup.py || die

	# Remove unrequested localization files:
	for lang in ${LINGUAS}; do
		use "linguas_${lang}" && continue
		rm -r "lib/locale/${lang}" || die
	done

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
		$(usex qt4      '' qt   )  \
		$(usex ncurses  '' text )  \
	; do
		rm gui/"${gui}"* -r || die
	done

	# And install requested ones...
	for gui in  \
		$(usex qt4      qt   '')  \
	; do
		setup_py_gui="${setup_py_gui}'electrum_gui.${gui}',"
	done

	sed -i "s/'electrum_gui\\.qt',/${setup_py_gui}/" setup.py || die

	local bestgui
	if use qt4; then
		bestgui=qt
	elif use ncurses; then
		bestgui=text
	else
		bestgui=stdio
	fi
	sed -i 's/^\([[:space:]]*\)\(config_options\['\''cwd'\''\] = .*\)$/\1\2\n\1config_options.setdefault("gui", "'"${bestgui}"'")\n/' electrum || die

	local plugin
	# trezor requires python trezorlib module
	# keepkey requires trezor
	for plugin in  \
		$(usex audio_modem     '' audio_modem          ) \
		$(usex cosign          '' cosigner_pool        ) \
		$(usex digitalbitbox   '' digitalbitbox        ) \
		$(usex email           '' email_requests       ) \
		$(usex greenaddress_it '' greenaddress_instant ) \
		hw_wallet \
		ledger \
		keepkey \
		$(usex sync            '' labels               ) \
		trezor  \
		$(usex trustedcoin_com '' trustedcoin          ) \
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
}

pkg_postrm() {
	gnome2_icon_cache_update
}
