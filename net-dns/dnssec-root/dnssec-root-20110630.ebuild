# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-root/dnssec-root-20110630.ebuild,v 1.16 2015/05/15 11:57:03 pacho Exp $

EAPI=4

DESCRIPTION="The DNSSEC root key(s)"
HOMEPAGE="https://www.iana.org/dnssec/"
SRC_URI="http://data.iana.org/root-anchors/root-anchors.xml -> root-anchors-20100715.xml
		http://data.iana.org/root-anchors/Kjqmt7v.csr -> Kjqmt7v-20100715.csr
		test? ( http://data.iana.org/root-anchors/Kjqmt7v.crt -> Kjqmt7v-20110630.crt
				http://data.iana.org/root-anchors/root-anchors.p7s -> root-anchors-20110630.p7s
				http://data.iana.org/root-anchors/root-anchors.asc -> root-anchors-20100715.asc
				http://data.iana.org/root-anchors/icannbundle.pem -> icannbundle-20100715.pem
				http://data.iana.org/root-anchors/icann.pgp -> icann-20110715.pgp
				)"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x64-macos"
IUSE="test"

RESTRICT="mirror"

RDEPEND=""
DEPEND="dev-libs/libxslt
		test? ( app-crypt/gnupg
			dev-libs/openssl )"

S="${WORKDIR}"

# xsl and checking as per:
# http://permalink.gmane.org/gmane.network.dns.unbound.user/1039

src_unpack() {
	return
}

src_compile() {
	xsltproc -o root-anchors-20100715.txt "${FILESDIR}"/anchors2ds.xsl "${DISTDIR}"/root-anchors-20100715.xml || die 'xsl translation failed'
}

src_test() {
	# icann.pgp contains an expired key
	# gpg --import "${DISTDIR}"/icann.pgp || die 'icann key import failed'
	gpg --import \
		"${FILESDIR}"/dnssec_at_iana.org_1024D_0F6C91D2-20120522.asc || die
	gpg --verify \
		"${DISTDIR}"/root-anchors-20100715.asc \
		"${DISTDIR}"/root-anchors-20100715.xml || die
	openssl smime  -verify \
		-content "${DISTDIR}"/root-anchors-20100715.xml \
		-in "${DISTDIR}"/root-anchors-20110630.p7s -inform der \
		-CAfile "${DISTDIR}"/icannbundle-20100715.pem || die
}

src_install() {
	insinto /etc/dnssec
	newins root-anchors-20100715.txt root-anchors.txt
	newins "${DISTDIR}"/root-anchors-20100715.xml root-anchors.xml
	newins "${DISTDIR}"/Kjqmt7v-20100715.csr Kjqmt7v.csr
}
