# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

MY_P="${P^g}"

DESCRIPTION="QDBM binding for Gauche"
HOMEPAGE="http://sourceforge.jp/projects/gauche/"
SRC_URI="mirror://sourceforge.jp/${PN%-*}/6988/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc x86"
IUSE=""

RDEPEND="dev-scheme/gauche
	dev-db/qdbm"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gauche-package.patch
	"${FILESDIR}"/${PN}-test.patch
	"${FILESDIR}"/${PN}-undefined-reference.patch
)

src_prepare() {
	default
	eautoreconf
}
