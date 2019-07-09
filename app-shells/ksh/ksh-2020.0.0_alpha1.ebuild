# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="https://github.com/att/ast"

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
SRC_URI="https://github.com/att/ast/releases/download/${MY_PV}/${MY_P}.tar.gz
	https://github.com/att/ast/commit/db7fe39b744d071bb0428c91e2eb84877f068dac.patch -> ksh-solaris.patch
	https://github.com/att/ast/commit/63e9edcb6084d4b164439065e2d71f3e900ec3c7.patch -> ksh-conftab.patch"
S="${WORKDIR}/${MY_P}"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="!app-shells/pdksh"

PATCHES=(
	"${DISTDIR}"/ksh-solaris.patch
	"${DISTDIR}"/ksh-conftab.patch
)

src_install() {
	meson_src_install
	dodir /bin
	mv "${ED}/usr/bin/ksh" "${ED}/bin/ksh" || die
}
