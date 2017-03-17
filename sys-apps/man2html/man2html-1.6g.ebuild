# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs

MY_P="man-${PV}"

DESCRIPTION="Standard commands to read man pages"
HOMEPAGE="http://primates.ximian.com/~flucifredi/man/"
SRC_URI="http://primates.ximian.com/~flucifredi/man/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="!sys-apps/man"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/man-1.6f-man2html-compression-2.patch
	epatch "${FILESDIR}"/man-1.6-cross-compile.patch
	epatch "${FILESDIR}"/man-1.6g-compress.patch #205147
}

echoit() { echo "$@" ; "$@" ; }
src_configure() {
	tc-export CC BUILD_CC

	# Just a stub to disable configure check.  man2html doesn't use it.
	export COMPRESS=true
	echoit \
	./configure \
		-confdir=/etc \
		+sgid +fhs \
		+lang none \
		|| die "configure failed"
}

src_compile() {
	emake {src,man2html}/Makefile
	emake -C src version.h
	emake -C man2html
}

src_install() {
	# A little faster to run this by hand than `emake install`.
	cd man2html
	dobin man2html
	doman man2html.1
	dodoc README TODO
}
