# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

MY_P="man-${PV}"

DESCRIPTION="Standard commands to read man pages"
HOMEPAGE="http://primates.ximian.com/~flucifredi/man/"
SRC_URI="http://primates.ximian.com/~flucifredi/man/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="!sys-apps/man"

PATCHES=(
	"${FILESDIR}"/man-1.6f-man2html-compression-2.patch
	"${FILESDIR}"/man-1.6-cross-compile.patch
	"${FILESDIR}"/man-1.6g-compress.patch #205147
	"${FILESDIR}"/man-1.6g-clang-15-configure.patch
)

src_configure() {
	tc-export CC BUILD_CC

	# Just a stub to disable configure check.  man2html doesn't use it.
	export COMPRESS=true
	edo ./configure \
		-confdir=/etc \
		+sgid +fhs \
		+lang none
}

src_compile() {
	emake {src,man2html}/Makefile
	emake -C src version.h
	emake -C man2html
}

src_install() {
	# A little faster to run this by hand than `emake install`.
	cd man2html || die

	dobin man2html
	doman man2html.1
	dodoc README TODO
}
