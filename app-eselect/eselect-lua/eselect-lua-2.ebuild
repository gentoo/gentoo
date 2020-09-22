# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lua eselect module"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="
	!dev-lang/lua:0
	>=app-admin/eselect-1.2.4
"
RDEPEND="${DEPEND}"
PDEPEND="
	|| (
		dev-lang/lua:5.1
		dev-lang/lua:5.2
		dev-lang/lua:5.3
		(
			dev-lang/luajit:2
			app-eselect/eselect-luajit
		)
	)
"
#		dev-lang/lua:5.4
# TODO: ^
S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/lua.eselect-${PV} lua.eselect
}
