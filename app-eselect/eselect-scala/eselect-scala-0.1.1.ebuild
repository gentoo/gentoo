# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Manages multiple Scala versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~gienah/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	doins scala.eselect
}
