# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Find deleted files in block devices"
HOMEPAGE="https://github.com/jbj/magicrescue"
SRC_URI="https://github.com/jbj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# - File collision with net-mail/safecat, bug #702004
# - BDEPEND on perl for pod2man, bug #852671
DEPEND="sys-libs/gdbm:="
RDEPEND="${DEPEND}
	!net-mail/safecat"
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-fhs-paths.patch"
)

src_configure() {
	tc-export CC

	# Not autotools, just looks like it sometimes
	./configure --prefix=/usr || die
}
