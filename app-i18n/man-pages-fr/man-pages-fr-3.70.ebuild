# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A somewhat comprehensive collection of french Linux man pages"
HOMEPAGE="https://traduc.org/perkamon"
SRC_URI="https://alioth.debian.org/frs/download.php/file/4119/${P}-1.tar.xz"

LICENSE="BSD FDL-1.1 FDL-1.2 GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/man"
DEPEND=""

S="${WORKDIR}/fr"

src_install() {
	dodoc README.fr
	doman -i18n=fr man*/*
}
