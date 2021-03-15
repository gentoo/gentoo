# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="
	http://www.tcptrace.org/download/${P/_p*}.tar.gz
	http://www.tcptrace.org/download/old/6.6/${P/_p*}.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P/_p*}-cross-compile.patch
	"${FILESDIR}"/${P/_p*}-_DEFAULT_SOURCE.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	default

	eapply \
		$(awk '{ print "'"${WORKDIR}"'/debian/patches/" $0; }' < "${WORKDIR}"/debian/patches/series)

	eautoreconf
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
