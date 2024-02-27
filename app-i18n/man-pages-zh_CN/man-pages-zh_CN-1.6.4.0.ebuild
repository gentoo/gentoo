# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A somewhat comprehensive collection of Chinese Linux man pages"
HOMEPAGE="https://github.com/man-pages-zh/manpages-zh"
MY_PN="manpages-zh"
MY_P="${MY_PN}-${PV}"
SRC_URI="https://github.com/man-pages-zh/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/man"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	# groups' zh_CN manpage is alrealy provided by sys-apps/shadow
	# to avoid file collision, we have to remove it
	rm src/man1/groups.1 || die

	doman -i18n=zh_CN src/man?/*.[1-9]*
	dodoc README.md AUTHORS ChangeLog NEWS
}
