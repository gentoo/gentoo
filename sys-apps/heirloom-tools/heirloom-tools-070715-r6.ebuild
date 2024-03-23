# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Heirloom toolchest - original Unix tools"
HOMEPAGE="https://heirloom.sourceforge.net/tools.html"
SRC_URI="mirror://sourceforge/heirloom/heirloom/${PV}/heirloom-${PV}.tar.bz2"
S="${WORKDIR}/heirloom-${PV}"

LICENSE="ZLIB BSD BSD-4 CDDL GPL-2+ LGPL-2.1+ LPL-1.02 Info-ZIP public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# slightly broken
RESTRICT="test"

RDEPEND="
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/ed
	app-alternatives/bc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-major.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-glibc-2.30.patch
	"${FILESDIR}"/${P}-glibc-2.31.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default
	sed -i "s:\bar\b:$(tc-getAR):g" libwchar/Makefile.mk || die
}

src_compile() {
	mypaths=(
		DEFBIN="${EPREFIX}/usr/lib/${PN}/5bin"
		SV3BIN="${EPREFIX}/usr/lib/${PN}/5bin"
		S42BIN="${EPREFIX}/usr/lib/${PN}/5bin/s42"
		SUSBIN="${EPREFIX}/usr/lib/${PN}/5bin/posix"
		SU3BIN="${EPREFIX}/usr/lib/${PN}/5bin/posix2001"
		UCBBIN="${EPREFIX}/usr/lib/${PN}/ucb"
		CCSBIN="${EPREFIX}/usr/lib/${PN}/ccs/bin"
		DEFLIB="${EPREFIX}/usr/lib/${PN}/5lib"
		DEFSBIN="${EPREFIX}/usr/lib/${PN}/5bin"
		MANDIR="${EPREFIX}/usr/share/man/5man"
		DFLDIR="${EPREFIX}/etc/default"
		SPELLHIST="/dev/null"
		SULOG="${EPREFIX}/var/log/sulog"
	)

	append-cppflags -D_GNU_SOURCE
	emake -j1 \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		CFLAGS="${CFLAGS}" \
		CFLAGS2="${CFLAGS}" \
		CFLAGSS="${CFLAGS}" \
		CFLAGSU="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LCURS="$($(tc-getPKG_CONFIG) --libs ncurses)" \
		LDFLAGS="${LDFLAGS}" \
		LIBZ="-lz" \
		"${mypaths[@]}"
}

src_install() {
	# we don't want to strip here, so use "true" as noop
	emake -j1 \
		STRIP="true" \
		ROOT="${D}" \
		"${mypaths[@]}" \
		install
	rm -r "${D}/dev" || die

	dodoc CHANGES README

	local DOC_CONTENTS="You may want to adjust your PATH, to enable
		using the apps of ${PN} by default.
		\\n\\nMan pages are installed in /usr/share/man/5man/.
		You may need to set MANPATH to access them."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
