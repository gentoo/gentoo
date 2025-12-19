# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Native Prolog compiler with constraint solving over finite domains (FD)"
HOMEPAGE="http://www.gprolog.org/"
SRC_URI="http://www.gprolog.org/${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="|| ( GPL-2+ LGPL-3+ )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc examples"

PATCHES=(
	# https://github.com/didoudiaz/gprolog/commit/0ba64c81255e910d68be2191fd1e688801320db8
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-links.patch
	"${FILESDIR}"/${P}-destdir.patch

	"${FILESDIR}"/${P}-llvm-as.patch
)

src_prepare() {
	default

	cd "${S}"/src || die
	eautoconf
}

src_configure() {
	# src/EnginePl/wam_archi.h:64:33: error: global register variable follows a function definition
	# https://bugs.gentoo.org/855599
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68384
	filter-lto
	# bug #943955
	append-cflags -std=gnu17

	CFLAGS_MACHINE="$(get-flag -march) $(get-flag -mcpu) $(get-flag -mtune)"

	use debug && append-flags -DDEBUG

	if tc-enables-pie; then
		# gplc generates its own native ASM; disable PIE
		append-ldflags -no-pie
	fi

	if tc-is-gcc && ! use x86; then
		gprolog_use_regs=yes
	else
		gprolog_use_regs=no
	fi

	if tc-is-clang; then
		AS=$(tc-getCC)
	else
		AS=$(tc-getAS)
	fi

	cd "${S}"/src || die
	local myeconfargs=(
		AS="${AS}"
		CFLAGS_MACHINE="${CFLAGS_MACHINE}"
		--with-c-flags="${CFLAGS}"
		--with-install-dir="${EPREFIX}"/usr/$(get_libdir)/${P}
		--with-links-dir="${EPREFIX}"/usr/bin
		--enable-regs=${gprolog_use_regs}
		$(use_with doc doc-dir "${EPREFIX}"/usr/share/doc/${PF})
		$(use_with doc html-dir "${EPREFIX}"/usr/share/doc/${PF}/html)
		$(use_with examples examples-dir "${EPREFIX}"/usr/share/doc/${PF}/examples)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	cd "${S}"/src || die

	# gprolog is compiled using gplc which cannot be run in parallel
	emake -j1
}

src_test() {
	cd "${S}"/src || die

	emake -j1 check
}

src_install() {
	cd "${S}"/src || die
	emake DESTDIR="${D}" TXT_FILES= install

	cd "${S}" || die
	dodoc ChangeLog NEWS PROBLEMS README
}
