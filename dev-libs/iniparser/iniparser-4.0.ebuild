# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="https://github.com/ndevilla/iniparser"
SRC_URI="https://github.com/ndevilla/iniparser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

DOCS=( AUTHORS README.md )

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-soname.patch
)

_newlib_so_with_symlinks() {
	local source="${1}" base="${2}" current="${3}" revision="${4}" age="${5}"
	local libdir="$(get_libdir)"

	newlib.so ${source} ${base}.so.${current}.${revision}.${age}
	for i in ".${current}" '' ; do
		dosym ${base}.so.${current}.${revision}.${age} /usr/${libdir}/${base}.so${i}
	done
}

src_prepare() {
	epatch "${PATCHES[@]}"
	rm -R html || die
}

src_compile() {
	emake CC="$(tc-getCC)" V=1
}

src_install() {
	newlib.a lib${PN}.a lib${PN}${SLOT}.a
	_newlib_so_with_symlinks lib${PN}.so lib${PN}${SLOT} 1 0 0

	insinto /usr/include/${PN}${SLOT}
	doins src/*.h

	if use doc; then
		emake -C doc
		dohtml -r html/*
	fi

	if use examples ; then
		local examplesdir="/usr/share/doc/${PF}/examples"
		insinto "${examplesdir}"
		doins example/*
		docompress -x "${examplesdir}"
	fi

	dodoc "${DOCS[@]}"
}

src_test() {
	emake -C test CC="$(tc-getCC)" V=1
}
