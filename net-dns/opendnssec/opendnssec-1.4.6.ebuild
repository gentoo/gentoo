# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/opendnssec/opendnssec-1.4.6.ebuild,v 1.1 2014/09/15 20:49:06 mschiff Exp $

EAPI=5

MY_P="${P/_}"
PKCS11_IUSE="+softhsm opensc external-hsm"
inherit base autotools multilib user

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.${PN}.org/files/source/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +mysql +signer sqlite test ${PKCS11_IUSE}"

RDEPEND="
	dev-lang/perl
	dev-libs/libxml2
	dev-libs/libxslt
	net-libs/ldns
	mysql? (
		virtual/mysql
		dev-perl/DBD-mysql
	)
	opensc? ( dev-libs/opensc )
	softhsm? ( dev-libs/softhsm )
	sqlite? (
		dev-db/sqlite:3
		dev-perl/DBD-SQLite
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		app-text/trang
	)
"

REQUIRED_USE="
	^^ ( mysql sqlite )
	^^ ( softhsm opensc external-hsm )
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-localstatedir.patch"
	"${FILESDIR}/${PN}-fix-run-dir.patch"
	"${FILESDIR}/${PN}-drop-privileges.patch"
	"${FILESDIR}/${PN}-use-system-trang.patch"
)

S="${WORKDIR}/${MY_P}"

DOCS=( MIGRATION NEWS )

check_pkcs11_setup() {
	# PKCS#11 HSM's are often only available with proprietary drivers not
	# available in portage tree.

	if use softhsm; then
		PKCS11_LIB=softhsm
		if has_version ">=dev-libs/softhsm-1.3.1"; then
			PKCS11_PATH=/usr/$(get_libdir)/softhsm/libsofthsm.so
		else
			PKCS11_PATH=/usr/$(get_libdir)/libsofthsm.so
		fi
		elog "Building with SoftHSM PKCS#11 library support."
	fi
	if use opensc; then
		PKCS11_LIB=opensc
		PKCS11_PATH=/usr/$(get_libdir)/opensc-pkcs11.so
		elog "Building with OpenSC PKCS#11 library support."
	fi
	if use external-hsm; then
		if [[ -n ${PKCS11_SCA6000} ]]; then
			PKCS11_LIB=sca6000
			PKCS11_PATH=${PKCS11_SCA6000}
		elif [[ -n ${PKCS11_ETOKEN} ]]; then
			PKCS11_LIB=etoken
			PKCS11_PATH=${PKCS11_ETOKEN}
		elif [[ -n ${PKCS11_NCIPHER} ]]; then
			PKCS11_LIB=ncipher
			PKCS11_PATH=${PKCS11_NCIPHER}
		elif [[ -n ${PKCS11_AEPKEYPER} ]]; then
			PKCS11_LIB=aepkeyper
			PKCS11_PATH=${PKCS11_AEPKEYPER}
		else
			ewarn "You enabled USE flag 'external-hsm' but did not specify a path to a PKCS#11"
			ewarn "library. To set a path, set one of the following environment variables:"
			ewarn "  for Sun Crypto Accelerator 6000, set: PKCS11_SCA6000=<path>"
			ewarn "  for Aladdin eToken, set: PKCS11_ETOKEN=<path>"
			ewarn "  for Thales/nCipher netHSM, set: PKCS11_NCIPHER=<path>"
			ewarn "  for AEP Keyper, set: PKCS11_AEPKEYPER=<path>"
			ewarn "Example:"
			ewarn "  PKCS11_ETOKEN=\"/opt/etoken/lib/libeTPkcs11.so\" emerge -pv opendnssec"
			ewarn "or store the variable into /etc/make.conf"
			die "USE flag 'external-hsm' set but no PKCS#11 library path specified."
		fi
		elog "Building with external PKCS#11 library support ($PKCS11_LIB): ${PKCS11_PATH}"
	fi
}

pkg_pretend() {
	check_pkcs11_setup
}

pkg_setup() {
	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec

	# pretend does not preserve variables so we need to run this once more
	check_pkcs11_setup
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--without-cunit \
		--localstatedir="${EPREFIX}/var/" \
		--disable-static \
		--with-database-backend=$(use mysql && echo "mysql")$(use sqlite && echo "sqlite3") \
		--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH} \
		$(use_enable debug timeshift) \
		$(use_enable signer)
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default

	# remove useless .la files
	find "${ED}" -name '*.la' -delete

	# Remove subversion tags from config files to avoid useless config updates
	sed -i \
		-e '/<!-- \$Id:/ d' \
		"${ED}"/etc/opendnssec/* || die

	# install update scripts
	insinto /usr/share/opendnssec
	if use sqlite; then
		doins enforcer/utils/migrate_keyshare_sqlite3.pl
		doins enforcer/utils/migrate_adapters_1.sqlite3
	fi
	if use mysql; then
		doins enforcer/utils/migrate_keyshare_mysql.pl
		doins enforcer/utils/migrate_adapters_1.mysql
	fi

	# fix permissions
	fowners root:opendnssec /etc/opendnssec
	fowners root:opendnssec /etc/opendnssec/{addns,conf,kasp,zonelist}.xml
	fowners opendnssec:opendnssec /var/lib/opendnssec/{,signconf,unsigned,signed,tmp}

	# install conf/init script
	newinitd "${FILESDIR}"/opendnssec.initd opendnssec
	newconfd "${FILESDIR}"/opendnssec.confd opendnssec
}

pkg_postinst() {
	local v
	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location writeable"
		elog "by the opendnssec user. You can set its location in /etc/softhsm.conf."
		elog "Suggested configuration is:"
		elog "    echo \"0:/var/lib/opendnssec/softhsm_slot0.db\" >> /etc/softhsm.conf"
		elog "    softhsm --init-token --slot 0 --label OpenDNSSEC"
		elog "    chown opendnssec:opendnssec /var/lib/opendnssec/softhsm_slot0.db"
	fi

	for v in $REPLACING_VERSIONS; do
		case $v in
			1.3.*)
				ewarn ""
				ewarn "You are upgrading from version 1.3."
				ewarn ""
				ewarn "Please be aware of the following:"
				ewarn "  * OpenDNSSEC now supports both input and output adapters for"
				ewarn "    AXFR and IXFR in addition to file transfer."
				ewarn "    -> The zonefetch.xml file has been replaced by addns.xml"
				ewarn "       to support this enhancement."
				ewarn "    -> changes to the KASP database mean that a database"
				ewarn "       migration is required to upgrade to 1.4 from earlier"
				ewarn "       versions of OpenDNSSEC."
				ewarn "  * The auditor is no longer supported."
				ewarn ""
				ewarn "You can find more information here:"
				ewarn "  * /usr/share/doc/opendnssec*/MIGRATION*"
				ewarn "  * https://wiki.opendnssec.org/display/DOCS/Migrating+zone+fetcher+to+DNS+adapters"
				ewarn "  * https://wiki.opendnssec.org/display/DOCS/Migrating+from+earlier+versions+of+OpenDNSSEC"
				ewarn ""
			;;
		esac
	done
}
