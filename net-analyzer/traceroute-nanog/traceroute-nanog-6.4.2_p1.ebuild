# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DEB_PL="1"
DESCRIPTION="Traceroute with AS lookup, TOS support, MTU discovery and other features"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="
	https://dev.gentoo.org/~jer/${PN}_${PV/_p*}.orig.tar.gz
	https://dev.gentoo.org/~jer/${PN}_${PV/_p*}-${PV/*_p}.diff.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

S=${WORKDIR}/${P/_p*}.orig

src_prepare() {
	eapply "${WORKDIR}"/${PN}_${PV/_p*}-${PV/*_p}.diff

	eapply \
		$(
			for i in $( cat "${S}"/debian/patches/00list )
			do
				echo "${S}"/debian/patches/$i.dpatch
			done
		)

	eapply_user
}

src_compile() {
	$(tc-getCC) traceroute.c -o ${PN} ${CFLAGS} -DSTRING ${LDFLAGS} -lresolv -lm \
		|| die
}

src_install() {
	dosbin traceroute-nanog
	dodoc 0_readme.txt faq.txt
	newman "${S}"/debian/traceroute-nanog.genuine.8 traceroute-nanog.8
}
