# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manages LuaJIT symlinks"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=app-admin/eselect-1.2.4
"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/luajit-${PV}.eselect" luajit.eselect || die "newins failed"
}
