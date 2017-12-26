# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="libmelf is a library interface for manipulating ELF object files"
HOMEPAGE="http://www.hick.org/code/skape/libmelf/"
SRC_URI="http://www.hick.org/code/skape/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	# This patch was gained from the elfsign-0.2.2 release
	"${FILESDIR}"/${PN}-0.4.1-unfinal-release.patch
	# Cleanup stuff
	"${FILESDIR}"/${PN}-0.4.0-r1-gcc-makefile-cleanup.patch
)

src_configure() {
	default
	append-flags -fPIC
}

src_compile() {
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}"
}

src_install() {
	into /usr
	dobin tools/elfres
	use static-libs && dolib.a libmelf.a
	dolib.so libmelf.so
	insinto /usr/include
	doins melf.h stdelf.h
	HTML_DOCS=( docs/html/. )
	einstalldocs
}
