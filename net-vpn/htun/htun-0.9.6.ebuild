# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Project to tunnel IP traffic over HTTP"
HOMEPAGE="http://linux.softpedia.com/get/System/Networking/HTun-14751.shtml"
SRC_URI="http://www.sourcefiles.org/Networking/Tools/Proxy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# should not be replaced by virtual/yacc
# at least failed with dev-util/bison
DEPEND="dev-util/yacc"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-glibc.patch #248100
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	# Fix multiple symbol definitions due to
	# C99/C11 inline semantics, bug 571458
	append-cflags -std=gnu89
}

src_compile() {
	emake -C src CC="$(tc-getCC)"
}

src_install() {
	dosbin src/htund

	insinto /etc
	doins doc/htund.conf

	local DOCS=( doc/. README )
	einstalldocs
	readme.gentoo_create_doc
}
