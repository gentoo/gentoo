# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

MY_P="${P^g}"

DESCRIPTION="QDBM binding for Gauche"
HOMEPAGE="https://osdn.jp/projects/gauche/"
SRC_URI="mirror://sourceforge.jp/${PN%-*}/6988/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~sparc x86"
IUSE=""

RDEPEND="dev-db/qdbm
	dev-scheme/gauche:="
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
