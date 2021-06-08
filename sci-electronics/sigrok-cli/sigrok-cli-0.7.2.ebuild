# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1 xdg-utils

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Command-line client for the sigrok logic analyzer software"
HOMEPAGE="https://sigrok.org/wiki/Sigrok-cli"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.32.0
	>=sci-libs/libsigrok-0.5.0:=
	decode? (
		>=sci-libs/libsigrokdecode-0.5.0:=[${PYTHON_SINGLE_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_with decode libsigrokdecode)
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
