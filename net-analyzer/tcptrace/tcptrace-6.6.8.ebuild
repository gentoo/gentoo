# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic

SERIAL="508f73a"

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="https://codeload.github.com/blitz/tcptrace/tar.gz/508f73a?dummy=/ -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${SERIAL}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	# FreeBSD patches (see https://www.freshports.org/net/tcptrace/?9kacyG=zRwZH1DfaB)
	"${FILESDIR}"/freebsd-accumulated.patch
	"${FILESDIR}"/fix-warnings.patch
	"${FILESDIR}"/${PN}-6.6.7-cross-compile.patch
	"${FILESDIR}"/${PN}-6.6.7-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${PN}-6.6.7-fix-build-clang16.patch
	"${FILESDIR}"/0001-configure.in-fix-implicit-function-declaration-causi.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861260
	#
	# Upstream site no longer exists.
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_compile() {
	emake CCOPT="${CFLAGS}"
}

src_install() {
	dobin tcptrace xpl2gpl

	newman tcptrace.man tcptrace.1
	dodoc CHANGES COPYRIGHT FAQ README* THANKS WWW
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN}; then
		elog "Note: tcptrace outputs its graphs in the xpl (xplot)"
		elog "format. Since xplot is unavailable, you will have to"
		elog "use the included xpl2gpl utility to convert it to"
		elog "the gnuplot format."
	fi
}
