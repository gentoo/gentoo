# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs qmake-utils verify-sig xdg-utils

DESCRIPTION="Handles text files containing ANSI terminal escape codes"
HOMEPAGE="
	http://andre-simon.de/doku/ansifilter/en/ansifilter.php
	https://gitlab.com/saalen/ansifilter/
"
SRC_URI="
	http://andre-simon.de/zip/${P}.tar.bz2
	gui? ( https://gitlab.com/uploads/-/system/project/avatar/6678914/ansifilter2_logo_256.png )
	verify-sig? ( http://andre-simon.de/zip/${P}.tar.bz2.asc )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="gui"

DEPEND="
	gui? ( dev-qt/qtbase:6[gui,widgets] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	verify-sig? ( >=sec-keys/openpgp-keys-andresimon-20240906 )
"

DOCS=( ChangeLog.adoc README.adoc  )

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/andresimon.asc

src_unpack() {
	if use verify-sig ; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.bz2{,.asc}
	fi

	default
}

src_prepare() {
	default

	sed \
		-e "/GZIP/d" \
		-e "/COPYING/d" \
		-i makefile || die

	sed \
		-e "s/-O2//" \
		-i src/makefile || die
}

src_configure() {
	if use gui ; then
		pushd src/qt-gui > /dev/null || die
		eqmake6
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -f makefile CXX="$(tc-getCXX)"

	if use gui ; then
		emake -C src/qt-gui
	fi
}

src_install() {
	emake -f makefile \
		DESTDIR="${ED}" \
		doc_dir="/usr/share/doc/${PF}" \
		-j1 \
		install $(usev gui install-gui)

	einstalldocs
	if use gui; then
		newicon -s 256 "${DISTDIR}"/ansifilter2_logo_256.png "${PN}".png
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
