# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs flag-o-matic

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="https://github.com/ndevilla/iniparser"
SRC_URI="https://github.com/ndevilla/iniparser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

DOCS=( AUTHORS README.md )

_newlib_so_with_symlinks() {
	local source="${1}" base="${2}" current="${3}" revision="${4}" age="${5}"
	local libdir="$(get_libdir)"

	newlib.so ${source} ${base}.so.${current}.${revision}.${age}
	for i in ".${current}" '' ; do
		dosym ${base}.so.${current}.${revision}.${age} /usr/${libdir}/${base}.so${i}
	done
}

src_prepare() {
	rm -R html || die
	eapply_user
}

src_configure() {
	append-lfs-flags
}

_emake() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" V=1 \
		SO_TARGET=lib${PN}${SLOT}.so.1 \
		ADDITIONAL_CFLAGS= \
		"$@"
}

src_compile() {
	_emake
}

src_test() {
	_emake -C test
}

src_install() {
	use static-libs && newlib.a lib${PN}.a lib${PN}${SLOT}.a
	_newlib_so_with_symlinks lib${PN}${SLOT}.so.1 lib${PN}${SLOT} 1 0 0

	insinto /usr/include/${PN}${SLOT}
	doins src/*.h

	if use doc; then
		emake -C doc
		HTML_DOCS=html/
	fi

	if use examples ; then
		local examplesdir="/usr/share/doc/${PF}/examples"
		insinto "${examplesdir}"
		doins example/*
		docompress -x "${examplesdir}"
	fi

	einstalldocs
}
