# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="The DNSSEC root key(s)"
HOMEPAGE="https://www.iana.org/dnssec/"
SRC_URI="https://data.iana.org/root-anchors/root-anchors.xml -> root-anchors-${PV}.xml
	https://data.iana.org/root-anchors/root-anchors.p7s -> root-anchors-${PV}.p7s
	https://data.iana.org/root-anchors/icannbundle.pem -> icannbundle-${PV}.pem"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE=""

BDEPEND=">=dev-perl/XML-XPath-1.420.0"
DEPEND=""

src_unpack() {
	mkdir "${S}" || die

	cp -t "${S}" "${DISTDIR}"/root-anchors-${PV}.{p7s,xml} "${DISTDIR}"/icannbundle-${PV}.pem || die
}

src_prepare() {
	mv root-anchors-${PV}.xml root-anchors.xml || die
	mv root-anchors-${PV}.p7s root-anchors.p7s || die
	mv icannbundle-${PV}.pem icannbundle.pem || die

	if has_version "dev-libs/openssl" ; then
		# Signature validating is optional:
		#   - We are already downloading SRC, signature file & CA from same URI
		#   - We store checksums for distfiles
		einfo "dev-libs/openssl is available, will validate signature of root-anchors.xml"
		openssl smime -verify \
			-content root-anchors.xml \
			-in root-anchors.p7s -inform der \
			-CAfile icannbundle.pem \
			-noverify || die "OpenSSL S/Mime verify failed"
	else
		einfo "dev-libs/openssl is not available, skipping optional validation root-anchors.xml"
	fi

	default
}

src_compile() {
	local KEYTAGS="" ALGORITHMS="" DIGESTTYPES="" DIGESTS="" i=1

	KEYTAGS=$(xpath -q -e '/TrustAnchor/KeyDigest/KeyTag/node()' root-anchors.xml)
	ALGORITHMS=$(xpath -q -e '/TrustAnchor/KeyDigest/Algorithm/node()' root-anchors.xml)
	DIGESTTYPES=$(xpath -q -e '/TrustAnchor/KeyDigest/DigestType/node()' root-anchors.xml)
	DIGESTS=$(xpath -q -e '/TrustAnchor/KeyDigest/Digest/node()' root-anchors.xml)
	while [ 1 ] ; do
		KEYTAG=$(echo ${KEYTAGS} | cut -d" " -f$i)
		[[ "${KEYTAG}" != "" ]] || break

		ALGORITHM=$(echo ${ALGORITHMS} | cut -d" " -f$i)
		[[ "${ALGORITHM}" == "" ]] && die "root-anchors.xml contains invalid key: ${KEYTAG} is missing algorithm"

		DIGESTTYPE=$(echo ${DIGESTTYPES} | cut -d" " -f$i)
		[[ "${DIGESTTYPE}" == "" ]] && die "root-anchors.xml contains invalid key: ${KEYTAG} is missing digest type"

		DIGEST=$(echo ${DIGESTS} | cut -d" " -f$i)
		[[ "${DIGEST}" == "" ]] && die "root-anchors.xml contains invalid key: ${KEYTAG} is missing digest"

		echo ". IN DS $KEYTAG $ALGORITHM $DIGESTTYPE $DIGEST" >> root-anchors.txt
		i=`expr $i + 1`
	done

	if [[ ! -s "root-anchors.txt" ]] ; then
		die "Sanity check failed: root-anchors.txt is empty or does not exist!"
	fi
}

src_install() {
	insinto /etc/dnssec
	doins root-anchors.{p7s,txt,xml} icannbundle.pem
}
