# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"
DOCS_DIR="doc"

PYTHON_COMPAT=( python3_{10..13} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 docs xdg

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eduvpn/python-${PN}.git"
	S="${WORKDIR}/${P}"
else
	# Development Versions use a different release signing key
	if [[ $(ver_cut 2) == 99 || $(ver_cut 3) == 99 ]] ; then
		VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eduvpn-dev.asc
	else
		VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eduvpn.asc
	fi
	inherit verify-sig
	MY_P="linux-app-${PV}"
	SRC_URI="
		https://codeberg.org/eduVPN/linux-app/releases/download/${PV}/${MY_P}.tar.xz -> ${P}.tar.xz
		verify-sig? ( https://codeberg.org/eduVPN/linux-app/releases/download/${PV}/${MY_P}.tar.xz.asc -> ${P}.tar.xz.asc )
	"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Linux client and Python client API for eduVPN"
HOMEPAGE="https://www.eduvpn.org/"

LICENSE="GPL-3+"
SLOT="0"

# Test suite involves adding NetworkManager configuration entries,
# disable for now.
RESTRICT="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-misc/networkmanager
	>=net-vpn/eduvpn-common-3[${PYTHON_USEDEP}]
	<net-vpn/eduvpn-common-4[${PYTHON_USEDEP}]
	x11-libs/libnotify
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-eduvpn-20240307 )"
fi

python_install() {
	distutils-r1_python_install
	# See utils.py: client supports loading from sys.prefix or
	# package_data dir. Move to the sys.prefix so desktop files work.
	# https://codeberg.org/eduVPN/linux-app/pulls/626
	rsync -a "${D}/$(python_get_sitedir)/eduvpn/data/share/"* \
		"${ED}/usr/share/" --remove-source-files || die
}
