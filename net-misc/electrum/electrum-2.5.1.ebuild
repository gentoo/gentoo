# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses?"

inherit eutils distutils-r1 gnome2-utils

MY_P="Electrum-${PV}"
DESCRIPTION="User friendly Bitcoin client"
HOMEPAGE="https://electrum.org/"
SRC_URI="https://download.electrum.org/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LINGUAS="ar_SA cs_CZ de_DE eo_UY fr_FR hy_AM it_IT ky_KG nb_NO no_NO pt_BR ro_RO sk_SK ta_IN vi_VN bg_BG da_DK el_GR es_ES hu_HU id_ID ja_JP lv_LV nl_NL pl_PL pt_PT ru_RU sl_SI th_TH zh_CN"

IUSE="cli cosign email +fiat greenaddress_it gtk3 ncurses qrcode +qt4 sync trustedcoin_com vkb"

for lingua in ${LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done

REQUIRED_USE="
	|| ( cli gtk3 ncurses qt4 )
	cosign? ( qt4 )
	email? ( qt4 )
	fiat? ( qt4 )
	greenaddress_it? ( qt4 )
	qrcode? ( qt4 )
	sync? ( qt4 )
	trustedcoin_com? ( qt4 )
	vkb? ( qt4 )
"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/slowaes[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/socksipy[${PYTHON_USEDEP}]
	dev-python/tlslite[${PYTHON_USEDEP}]
	dev-libs/protobuf[python,${PYTHON_USEDEP}]
	virtual/python-dnspython[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[python,v4l,${PYTHON_USEDEP}] )
	gtk3? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)
	qt4? (
		dev-python/PyQt4[${PYTHON_USEDEP}]
	)
	ncurses? ( dev-lang/python )
"

S="${WORKDIR}/${MY_P}"

DOCS="RELEASE-NOTES"

src_prepare() {
	# Don't advise using PIP
	sed -i "s/On Linux, try 'sudo pip install zbar'/Re-emerge Electrum with the qrcode USE flag/" lib/qrscanner.py || die

	# Prevent icon from being installed in the wrong location
	sed -i '/icons/d' setup.py || die

	validate_desktop_entries

	# Remove unrequested localization files:
	for lang in ${LINGUAS}; do
		use "linguas_${lang}" && continue
		rm -r "lib/locale/${lang}" || die
	done

	local wordlist=
	for wordlist in  \
		$(usex linguas_ja_JP '' japanese) \
		$(usex linguas_pt_BR '' portuguese) \
		$(usex linguas_pt_PT '' portuguese) \
		$(usex linguas_es_ES '' spanish) \
		$(usex linguas_zh_CN '' chinese_simplified) \
	; do
		rm -f "lib/wordlist/${wordlist}.txt" || die
		sed -i "/${wordlist}\\.txt/d" lib/mnemonic.py || die
	done

	# Remove unrequested GUI implementations:
	rm -rf gui/android*
	rm -rf gui/jsonrpc*
	rm -rf gui/kivy*
	local gui
	for gui in  \
		$(usex cli      '' stdio)  \
		$(usex gtk3     '' gtk  )  \
		$(usex qt4      '' qt   )  \
		$(usex ncurses  '' text )  \
	; do
		rm gui/"${gui}"* -r || die
	done

	if ! use qt4; then
		sed -i "s/'electrum_gui\\.qt',//" setup.py || die
		local bestgui=$(usex gtk3 gtk $(usex ncurses text stdio))
		sed -i "s/\(config.get('gui', \?\)'classic'/\1'${bestgui}'/" electrum || die
	fi

	local plugin
	# btchipwallet requires python btchip module (and dev-python/pyusb)
	# trezor requires python trezorlib module
	# keepkey requires trezor
	for plugin in  \
		$(usex cosign        '' cosigner_pool   )  \
		$(usex email         '' email_requests  )  \
		$(usex fiat          '' exchange_rate   )  \
		$(usex greenaddress_it '' greenaddress_instant)  \
		keepkey \
		$(usex sync          '' labels          )  \
		trezor  \
		$(usex trustedcoin_com '' trustedcoin   )  \
		$(usex vkb           '' virtualkeyboard )  \
	; do
		rm plugins/"${plugin}"* || die
	done

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
