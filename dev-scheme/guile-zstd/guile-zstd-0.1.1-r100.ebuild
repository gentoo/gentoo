# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="GNU Guile bindings to the zstd compression library"
HOMEPAGE="https://notabug.org/guile-zstd/guile-zstd/"

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

REQUIRED_USED="${GUILE_REQUIRED_USE}"

# In zstd-1.5.5-r1 library was moved back from "/lib" to "/usr/lib".
RDEPEND="
	${GUILE_DEPS}
	>=app-arch/zstd-1.5.5-r1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	guile_src_prepare
	eautoreconf
}
