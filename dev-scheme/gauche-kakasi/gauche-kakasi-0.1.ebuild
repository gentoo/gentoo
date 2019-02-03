# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

MY_P="${P^g}"

DESCRIPTION="Kakasi binding for Gauche"
HOMEPAGE="http://sourceforge.jp/projects/gauche/"
SRC_URI="mirror://sourceforge/${PN%-*}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 x86"
IUSE=""

RDEPEND="dev-scheme/gauche
	>=app-i18n/kakasi-2.3.4"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-gauche-package.patch )

src_prepare() {
	default

	mv configure.{in,ac}
	eautoreconf
}
