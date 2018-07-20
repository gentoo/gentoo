# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
SRC_URI="https://github.com/adrianlopezroche/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

src_prepare() {
	append-lfs-flags
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin fdupes
	doman fdupes.1
	dodoc CHANGES CONTRIBUTORS README TODO
}
