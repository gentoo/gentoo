# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 3-0 )
inherit autotools guile

DESCRIPTION="GNU Guile library providing bindings to zlib"
HOMEPAGE="https://notabug.org/guile-zlib/guile-zlib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://notabug.org/${PN}/${PN}.git"
else
	SRC_URI="https://notabug.org/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	>=sys-libs/zlib-1.3-r4
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README.org )

PATCHES=( "${FILESDIR}/${PN}-0.1.0-gentoo.patch" )

src_prepare() {
	guile_src_prepare

	eautoreconf
}
