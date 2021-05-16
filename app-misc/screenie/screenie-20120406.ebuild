# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A small and lightweight screen wrapper"
HOMEPAGE="https://sourceforge.net/projects/screenie/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 sparc x86"

RDEPEND="app-misc/screen"

S="${WORKDIR}/${PN}"

src_install() {
	einstalldocs
	dobin screenie
	doman screenie.1
}
