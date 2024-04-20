# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="
	http://www.tcptrace.org/download/${P/_p*}.tar.gz
	http://www.tcptrace.org/download/old/$(ver_cut 1-2)/${P/_p*}.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"
S=${WORKDIR}/${P/_p*}

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
	"${FILESDIR}"/${P/_p*}-cross-compile.patch
	"${FILESDIR}"/${P/_p*}-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${P/_p*}-fix-build-clang16.patch
	"${FILESDIR}"/0001-configure.in-fix-implicit-function-declaration-causi.patch
)

src_prepare() {
	default

	eapply \
		$(awk '{ print "'"${WORKDIR}"'/debian/patches/" $0; }' < "${WORKDIR}"/debian/patches/series)

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
