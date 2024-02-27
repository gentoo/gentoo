# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 xdg-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eduvpn/python-${PN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/eduvpn/python-eduvpn-client/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/python-${P}"
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
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=net-vpn/eduvpn-common-1.1.2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-desktop.patch"
)

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
