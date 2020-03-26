# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
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
DEPEND=${RDEPEND}
BDEPEND="
	sys-apps/ed
	sys-devel/bc
	virtual/pkgconfig
"
S="${WORKDIR}/heirloom-${PV}"
PATCHES=(
	"${FILESDIR}"/${P}-major.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-glibc-2.30.patch
	"${FILESDIR}"/${P}-glibc-2.31.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)

# slightly broken
RESTRICT="test"

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake -j1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CFLAGS2="${CFLAGS}" \
		CFLAGSS="${CFLAGS}" \
		CFLAGSU="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LCURS="$( $(tc-getPKG_CONFIG) --libs ncurses)" \
		LDFLAGS="${LDFLAGS}" \
		ROOT="${ED}" \
		DEFBIN="/usr/bin/${PN}/5bin" \
		DEFSBIN="/usr/bin/${PN}/5bin" \
		SV3BIN="/usr/bin/${PN}/5bin" \
		S42BIN="/usr/bin/${PN}/5bin/s42" \
		SUSBIN="/usr/bin/${PN}/5bin/posix" \
		UCBBIN="/usr/bin/${PN}/ucb" \
		CCSBIN="/usr/bin/${PN}/ccs/bin" \
		SU3BIN="/usr/bin/${PN}/5bin/posix2001" \
		DEFLIB="/usr/bin/${PN}/5lib" \
		LIBZ=-lz
}

src_install() {
	# we don't want to strip here, so use "true" as noop
	emake -j1 \
		STRIP="true" \
		ROOT="${ED}" \
		DEFBIN="/usr/bin/${PN}/5bin" \
		DEFSBIN="/usr/bin/${PN}/5bin" \
		SV3BIN="/usr/bin/${PN}/5bin" \
		S42BIN="/usr/bin/${PN}/5bin/s42" \
		SUSBIN="/usr/bin/${PN}/5bin/posix" \
		UCBBIN="/usr/bin/${PN}/ucb" \
		CCSBIN="/usr/bin/${PN}/ccs/bin" \
		SU3BIN="/usr/bin/${PN}/5bin/posix2001" \
		DEFLIB="/usr/bin/${PN}/5lib" \
		install
}

pkg_postinst() {
	elog "You may want to adjust your \$PATH, to enable "
	elog "using the apps of heirloom toolchest by default."
	elog "Man pages are installed in /usr/share/man/5man/"
	elog "You may need to set \$MANPATH to access them."
}
