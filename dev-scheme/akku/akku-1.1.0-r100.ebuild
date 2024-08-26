# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Language package manager for Scheme"
HOMEPAGE="https://akkuscm.org/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/akkuscm/${PN}.git"
else
	SRC_URI="https://gitlab.com/akkuscm/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

# tests require network access
RESTRICT="test"

RDEPEND="
	${GUILE_DEPS}
	net-misc/curl[ssl]
"
DEPEND="${RDEPEND}"

# Installs into its own path
# https://gitlab.com/akkuscm/akku/-/commit/d25da297fec2a2b16427359a2cbb0ec745dd8c58
QA_PREBUILT="usr/*/${PN}/guile/*/site-ccache/*"

src_prepare() {
	guile_src_prepare

	eautoreconf
}

src_compile() {
	touch bootstrap.db || die

	guile_src_compile
}
