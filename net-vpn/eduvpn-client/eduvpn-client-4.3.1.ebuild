# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"
DOCS_DIR="doc"

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 docs xdg-utils

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
	MY_P="python-${P}"
	SRC_URI="
		https://github.com/eduvpn/python-eduvpn-client/releases/download/${PV}/${MY_P}.tar.xz
		verify-sig? ( https://github.com/eduvpn/python-eduvpn-client/releases/download/${PV}/${MY_P}.tar.xz.asc )
	"
	KEYWORDS="~amd64 ~x86"
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
	=net-vpn/eduvpn-common-2*[${PYTHON_USEDEP}]
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-eduvpn-20240307 )"
fi

PATCHES=(
	"${FILESDIR}/${PN}-4.3.1-desktop.patch"
)

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
