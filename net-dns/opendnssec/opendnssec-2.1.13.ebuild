# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_}"
PKCS11_IUSE="+softhsm opensc external-hsm"

inherit autotools

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="https://www.opendnssec.org/"
SRC_URI="https://www.${PN}.org/files/source/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +mysql readline +signer sqlite test ${PKCS11_IUSE}"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/opendnssec
	acct-user/opendnssec
	dev-lang/perl
	dev-libs/libxml2
	dev-libs/libxslt
	net-libs/ldns[ed25519(+),ed448(+)]
	mysql? (
		dev-db/mysql-connector-c:0=
		dev-perl/DBD-mysql
	)
	opensc? ( dev-libs/opensc )
	readline? ( sys-libs/readline:0 )
	softhsm? ( dev-libs/softhsm:* )
	sqlite? (
		dev-db/sqlite:3
		dev-perl/DBD-SQLite
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-doc/doxygen )
	test? (
		app-text/trang
		dev-libs/softhsm:*
		dev-util/cunit
	)
"

REQUIRED_USE="
	^^ ( mysql sqlite )
	^^ ( softhsm opensc external-hsm )
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-run-dir-2.1.x.patch"
	"${FILESDIR}/${PN}-use-system-trang.patch"
	"${FILESDIR}/${PN}-fix-mysql.patch"
)

DOCS=( MIGRATION NEWS )

check_pkcs11_setup() {
	# PKCS#11 HSM's are often only available with proprietary drivers not
	# available in portage tree.

	if use softhsm; then
		PKCS11_LIB=softhsm
		PKCS11_PATH=/usr/$(get_libdir)/softhsm/libsofthsm2.so
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
			ewarn "or store the variable into /etc/portage/make.conf"
			die "USE flag 'external-hsm' set but no PKCS#11 library path specified."
		fi
		elog "Building with external PKCS#11 library support ($PKCS11_LIB): ${PKCS11_PATH}"
	fi
}

pkg_pretend() {
	if has_version "<net-dns/opendnssec-1.4.10"; then
		################################################################################
		eerror "You are already using OpenDNSSEC."
		eerror "In order to migrate to version >=2.0.0 you need to upgrade to"
		eerror "version >=1.4.10 first:"
		eerror ""
		eerror "   emerge \"<net-dns/opendnssec-2\""
		eerror ""
		eerror "See /usr/share/doc/opendnssec-2.1.10/MIGRATION* for details."
		eerror ""
		die "Please upgrade to version >=1.4.10 first for proper db migraion"
	fi

	check_pkcs11_setup
}

pkg_setup() {
	# pretend does not preserve variables so we need to run this once more
	check_pkcs11_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
#		--localstatedir="${EPREFIX}/var/lib" \
	econf \
		--enable-installation-user=opendnssec \
		--enable-installation-group=opendnssec \
		--without-cunit \
		--disable-static \
		--with-enforcer-database=$(use mysql && echo "mysql")$(use sqlite && echo "sqlite3") \
		--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH} \
		$(use_with readline) \
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

	# install db update/migration stuff
	insinto /usr/share/opendnssec/db
	if use sqlite; then
		doins enforcer/utils/convert_mysql_to_sqlite
	fi
	if use mysql; then
		doins enforcer/utils/convert_sqlite_to_mysql
	fi

	insinto /usr/share/opendnssec/db/sql
	if use sqlite; then
		doins enforcer/src/db/schema.sqlite
	fi
	if use mysql; then
		doins enforcer/src/db/schema.mysql
	fi

	insinto /usr/share/opendnssec/db/1.4-2.0_db_convert
	doins enforcer/utils/1.4-2.0_db_convert/find_problematic_zones.sql
	doins enforcer/utils/1.4-2.0_db_convert/README.md
	if use sqlite; then
		doins enforcer/utils/1.4-2.0_db_convert/sqlite_convert.sql
		doins enforcer/utils/1.4-2.0_db_convert/convert_sqlite
	fi
	if use mysql; then
		doins enforcer/utils/1.4-2.0_db_convert/convert_mysql
		doins enforcer/utils/1.4-2.0_db_convert/mysql_convert.sql
	fi

	# patch scripts to find schema files
	sed -i \
		-e 's,^SCHEMA=../src/db/,SCHEMA=/usr/share/opendnssec/db/sql/,' \
		-e 's,^SCHEMA=../../src/db/,SCHEMA=/usr/share/opendnssec/db/sql/,' \
		"${ED}"/usr/share/opendnssec/db/convert_* \
		"${ED}"/usr/share/opendnssec/db/1.4-2.0_db_convert/convert_* || die

	# create directories
	keepdir /var/lib/opendnssec/{,enforcer,signconf,signed,signer,unsigned}

	# fix permissions
	fowners root:opendnssec /etc/opendnssec
	fowners root:opendnssec /etc/opendnssec/{addns,conf,kasp,zonelist}.xml
	fowners opendnssec:opendnssec /var/lib/opendnssec/{,enforcer,signconf,signed,signer,unsigned}

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
			1.4.*)
				ewarn ""
				ewarn "You are upgrading from version 1.4."
				ewarn ""
				ewarn "A migration is needed from 1.4 to 2.x."
				ewarn "For details see /usr/share/doc/${P}/MIGRATION*"
				ewarn ""
				ewarn "For your convenience the mentioned migration scripts and README"
				ewarn "have been installed to /usr/share/${PN}/db/1.4-2.0_db_convert"
				ewarn ""
			;;
		esac
	done
}
