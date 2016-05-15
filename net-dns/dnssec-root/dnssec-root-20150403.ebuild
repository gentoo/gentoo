# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The DNSSEC root key(s)"
HOMEPAGE="https://www.iana.org/dnssec/"
DATE_ISSUE1=20100715 # Original root-anchor creation date
DATE_ISSUE2=20110715 # ICANN PGP key updated
DATE_ISSUE3=20150504 # Subordinate CAs updated
ICANN_PGP_FINGERPRINT='2FBB91BCAAEE0ABE1F8031C7D1AFBCE00F6C91D2'
# The naming of the files really needs some improvement upstream:
# root-anchors.p7s despite it's name, is mostly the the same data as
# icannbundle.pem
SRC_URI="http://data.iana.org/root-anchors/root-anchors.xml -> root-anchors-${DATE_ISSUE1}.xml
		http://data.iana.org/root-anchors/Kjqmt7v.csr -> Kjqmt7v-${DATE_ISSUE1}.csr
		test? ( http://data.iana.org/root-anchors/Kjqmt7v.crt -> Kjqmt7v-${DATE_ISSUE3}.crt
				http://data.iana.org/root-anchors/root-anchors.p7s -> root-anchors-${DATE_ISSUE3}.p7s
				http://data.iana.org/root-anchors/root-anchors.asc -> root-anchors-${DATE_ISSUE1}.asc
				http://data.iana.org/root-anchors/icannbundle.pem -> icannbundle-${DATE_ISSUE3}.pem
				http://data.iana.org/root-anchors/icann.pgp -> icann-${DATE_ISSUE2}.pgp
				)"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-macos"
IUSE="test"

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

src_prepare() {
	return
}

src_compile() {
	xsltproc \
		-o root-anchors-${DATE_ISSUE1}.txt \
		"${FILESDIR}"/anchors2ds.xsl \
		"${DISTDIR}"/root-anchors-${DATE_ISSUE1}.xml \
		|| die 'xsl translation failed'
}

src_test() {
	# This is a terrible catch-22 of security, since we get the ICANN key from the
	# same site! We verify the fingerprint ourselves in case
	gpg --import "${DISTDIR}"/icann-${DATE_ISSUE2}.pgp || die 'ICANN key import failed'
	gpg --fingerprint --with-colon --list-keys \
		| grep '^fpr:' | fgrep ":$ICANN_PGP_FINGERPRINT:" \
		|| die "ICANN key fingerprint mismatch!"
	#gpg --import \
	#	"${FILESDIR}"/dnssec_at_iana.org_1024D_0F6C91D2-20120522.asc || die
	gpg --verify \
		"${DISTDIR}"/root-anchors-${DATE_ISSUE1}.asc \
		"${DISTDIR}"/root-anchors-${DATE_ISSUE1}.xml || die "GPG verify failed"
	openssl smime  -verify \
		-content "${DISTDIR}"/root-anchors-${DATE_ISSUE1}.xml \
		-in "${DISTDIR}"/root-anchors-${DATE_ISSUE3}.p7s -inform der \
		-CAfile "${DISTDIR}"/icannbundle-${DATE_ISSUE3}.pem || die "OpenSSL smime verify failed"
}

src_install() {
	insinto /etc/dnssec
	newins root-anchors-${DATE_ISSUE1}.txt root-anchors.txt
	newins "${DISTDIR}"/root-anchors-${DATE_ISSUE1}.xml root-anchors.xml
	# What actually uses the DER-format certificate request out of the box?
	# Wouldn't icannbundle.pem or Kjqmt7v.crt (converted to PEM format) be more
	# useful?
	newins "${DISTDIR}"/Kjqmt7v-${DATE_ISSUE1}.csr Kjqmt7v.csr
}
