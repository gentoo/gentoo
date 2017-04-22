# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="Scans for and fixes broken or messy symlinks"
HOMEPAGE="http://www.ibiblio.org/pub/linux/utils/file/"
SRC_URI="http://www.ibiblio.org/pub/linux/utils/file/${P}.tar.gz"

LICENSE="symlinks"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="static"

DOCS=( symlinks.lsm )

src_prepare() {
	default
	# could be useful if being used to repair
	# symlinks that are preventing shared libraries from
	# functioning.
	use static && append-flags -static
	append-lfs-flags
	sed 's:-O2::g' -i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.8"
}
