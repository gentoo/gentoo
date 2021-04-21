# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A native Prolog compiler with constraint solving over finite domains (FD)"
HOMEPAGE="http://www.gprolog.org/"
SRC_URI="http://www.gprolog.org/${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="|| ( GPL-2+ LGPL-3+ )"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="debug doc examples"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-links.patch
	"${FILESDIR}"/${P}-nodocs.patch
	"${FILESDIR}"/${P}-txt-file.patch
	"${FILESDIR}"/${P}-check-boot.patch
)

src_configure() {
	CFLAGS_MACHINE="`get-flag -march` `get-flag -mcpu` `get-flag -mtune`"

	# Work around -fno-common (GCC 10 default), bug #71202
	append-flags -fcommon

	append-flags -fno-strict-aliasing
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

	cd "${S}"/src || die
	econf \
		CFLAGS_MACHINE="${CFLAGS_MACHINE}" \
		--with-c-flags="${CFLAGS}" \
		--with-install-dir="${EPREFIX}"/usr/$(get_libdir)/${P} \
		--with-links-dir="${EPREFIX}"/usr/bin \
		--enable-regs=${gprolog_use_regs} \
		$(use_with doc doc-dir "${EPREFIX}"/usr/share/doc/${PF}) \
		$(use_with doc html-dir "${EPREFIX}"/usr/share/doc/${PF}/html) \
		$(use_with examples examples-dir "${EPREFIX}"/usr/share/doc/${PF}/examples)
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
	emake DESTDIR="${D}" install

	cd "${S}" || die
	dodoc ChangeLog NEWS PROBLEMS README
}
