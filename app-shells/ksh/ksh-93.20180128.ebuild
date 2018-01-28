# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson prefix

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="http://www.kornshell.com/"

COMMIT="0c8dbe3001d1bbef4f76673dc9c1629d90da9862"
SRC_URI="https://github.com/att/ast/archive/${COMMIT}/${P}.tar.gz"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="!app-shells/pdksh"

S="${WORKDIR}/ast-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/ksh-prefix-r1.patch
)

src_prepare() {
	default
	eprefixify src/cmd/ksh93/data/msg.c
}

src_install() {
	meson_src_install
	dodir /bin
	mv "${ED%/}"{/usr,}/bin/ksh || die
}
