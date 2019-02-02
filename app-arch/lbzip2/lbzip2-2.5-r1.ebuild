# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Parallel bzip2 utility"
HOMEPAGE="https://github.com/kjn/lbzip2/"
SRC_URI="http://archive.lbzip2.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug symlink"

RDEPEND="symlink? ( !app-arch/pbzip2[symlink] )"
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-s_isreg.patch
	# bug 669594
	"${FILESDIR}"/${PN}-2.5-glibc-2.28.patch
)

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug tracing)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use symlink; then
		dosym ${PN} /usr/bin/bzip2
		dosym lbunzip2 /usr/bin/bunzip2
	fi
}
