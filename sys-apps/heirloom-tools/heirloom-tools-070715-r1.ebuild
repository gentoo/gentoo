# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Heirloom toolchest - original Unix tools"
HOMEPAGE="http://heirloom.sourceforge.net/tools.html"
SRC_URI="http://downloads.sourceforge.net/project/heirloom/heirloom/${PV}/heirloom-${PV}.tar.bz2"

LICENSE="CDDL GPL-2 LGPL-2.1 9base ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	sys-apps/ed
	virtual/pkgconfig
"
S="${WORKDIR}/heirloom-${PV}"
PATCHES=(
	"${FILESDIR}"/${P}-major.patch
	"${FILESDIR}"/${P}-glibc-2.30.patch
	"${FILESDIR}"/${P}-glibc-2.31.patch
)

# slightly broken
RESTRICT="test"

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake -j1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LCURS="$( $(tc-getPKG_CONFIG) --libs ncurses)" \
		LDFLAGS="${LDFLAGS}" \
		LIBZ=-lz
}

src_install() {
	# we don't want to strip here, so use "true" as noop
	emake STRIP="true" ROOT="${D}" -j1 install
}

pkg_postinst() {
	elog "You may want to add /usr/5bin or /usr/ucb to \$PATH"
	elog "to enable using the apps of heirloom toolchest by default."
	elog "Man pages are installed in /usr/share/man/5man/"
	elog "You may need to set \$MANPATH to access them."
}
