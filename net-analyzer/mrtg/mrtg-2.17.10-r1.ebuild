# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A tool to monitor the traffic load on network-links"
HOMEPAGE="https://oss.oetiker.ch/mrtg/"
SRC_URI="https://oss.oetiker.ch/mrtg/pub/${P}.tar.gz https://github.com/oetiker/mrtg/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 sparc x86"
IUSE="selinux"

DEPEND="dev-lang/perl
	>=dev-perl/SNMP_Session-1.13-r2
	>=dev-perl/Socket6-0.23
	media-libs/gd[png]"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-mrtg )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.17.4-socket6.patch
	"${FILESDIR}"/${PN}-2.17.10-implicit.patch
)

src_prepare() {
	default
	eautoreconf

	rm ./lib/mrtg2/{SNMP_{Session,util},BER}.pm || die

	sed -i \
		-e 's|main::SL}lib${main::SL|main::SL}'"$(get_libdir)"'${main::SL|g' \
		$(find bin -type f) contrib/cfgmaker_dlci/cfgmaker_dlci || die
}

src_install() {
	keepdir /var/lib/mrtg

	default

	mv "${ED}"/usr/share/doc/{mrtg2,${PF}} || die

	newinitd "${FILESDIR}/mrtg.rc" ${PN}
	newconfd "${FILESDIR}/mrtg.confd" ${PN}
}
