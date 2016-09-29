# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit db-use eutils flag-o-matic multilib multilib-minimal ssl-cert versionator toolchain-funcs autotools user systemd

BIS_PN=rfc2307bis.schema
BIS_PV=20140524
BIS_P="${BIS_PN}-${BIS_PV}"

DESCRIPTION="LDAP suite of application and development tools"
HOMEPAGE="http://www.OpenLDAP.org/"

# mirrors are mostly not working, using canonical URI
SRC_URI="ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${P}.tgz
		 mirror://gentoo/${BIS_P}"

LICENSE="OPENLDAP GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

IUSE_DAEMON="crypt icu samba slp tcpd experimental minimal"
IUSE_BACKEND="+berkdb"
IUSE_OVERLAY="overlays perl"
IUSE_OPTIONAL="gnutls iodbc sasl ssl odbc debug ipv6 libressl +syslog selinux static-libs"
IUSE_CONTRIB="smbkrb5passwd kerberos kinit"
IUSE_CONTRIB="${IUSE_CONTRIB} -cxx"
IUSE="${IUSE_DAEMON} ${IUSE_BACKEND} ${IUSE_OVERLAY} ${IUSE_OPTIONAL} ${IUSE_CONTRIB}"

REQUIRED_USE="cxx? ( sasl )
	?? ( gnutls libressl )"

# always list newer first
# Do not add any AGPL-3 BDB here!
# See bug 525110, comment 15.
BDB_SLOTS='5.3 5.1 4.8 4.7 4.6 4.5 4.4'
BDB_PKGS=''
for _slot in $BDB_SLOTS; do BDB_PKGS="${BDB_PKGS} sys-libs/db:${_slot}" ; done

# openssl is needed to generate lanman-passwords required by samba
CDEPEND="icu? ( dev-libs/icu:= )
	ssl? (
		!gnutls? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
		)
		gnutls? ( >=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}]
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
		>=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] ) )
	sasl? ( dev-libs/cyrus-sasl:= )
	!minimal? (
		sys-devel/libtool
		sys-libs/e2fsprogs-libs
		>=dev-db/lmdb-0.9.14:=
		tcpd? ( sys-apps/tcp-wrappers )
		odbc? ( !iodbc? ( dev-db/unixODBC )
			iodbc? ( dev-db/libiodbc ) )
		slp? ( net-libs/openslp )
		perl? ( dev-lang/perl:=[-build(-)] )
		samba? (
			!libressl? ( dev-libs/openssl:0 )
			libressl? ( dev-libs/libressl )
		)
		berkdb? (
			<sys-libs/db-6.0:=
			|| ( ${BDB_PKGS} )
			)
		smbkrb5passwd? (
			!libressl? ( dev-libs/openssl:0 )
			libressl? ( dev-libs/libressl )
			kerberos? ( app-crypt/heimdal )
			)
		kerberos? (
			virtual/krb5
			kinit? ( !app-crypt/heimdal )
			)
		cxx? ( dev-libs/cyrus-sasl:= )
	)
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r3
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${CDEPEND}
	sys-apps/groff"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-ldap )
"
# for tracking versions
OPENLDAP_VERSIONTAG=".version-tag"
OPENLDAP_DEFAULTDIR_VERSIONTAG="/var/lib/openldap-data"

MULTILIB_WRAPPED_HEADERS=(
	# USE=cxx
	/usr/include/LDAPAsynConnection.h
	/usr/include/LDAPAttrType.h
	/usr/include/LDAPAttribute.h
	/usr/include/LDAPAttributeList.h
	/usr/include/LDAPConnection.h
	/usr/include/LDAPConstraints.h
	/usr/include/LDAPControl.h
	/usr/include/LDAPControlSet.h
	/usr/include/LDAPEntry.h
	/usr/include/LDAPEntryList.h
	/usr/include/LDAPException.h
	/usr/include/LDAPExtResult.h
	/usr/include/LDAPMessage.h
	/usr/include/LDAPMessageQueue.h
	/usr/include/LDAPModList.h
	/usr/include/LDAPModification.h
	/usr/include/LDAPObjClass.h
	/usr/include/LDAPRebind.h
	/usr/include/LDAPRebindAuth.h
	/usr/include/LDAPReferenceList.h
	/usr/include/LDAPResult.h
	/usr/include/LDAPSaslBindResult.h
	/usr/include/LDAPSchema.h
	/usr/include/LDAPSearchReference.h
	/usr/include/LDAPSearchResult.h
	/usr/include/LDAPSearchResults.h
	/usr/include/LDAPUrl.h
	/usr/include/LDAPUrlList.h
	/usr/include/LdifReader.h
	/usr/include/LdifWriter.h
	/usr/include/SaslInteraction.h
	/usr/include/SaslInteractionHandler.h
	/usr/include/StringList.h
	/usr/include/TlsOptions.h
)

openldap_filecount() {
	local dir="$1"
	find "${dir}" -type f ! -name '.*' ! -name 'DB_CONFIG*' | wc -l
}

openldap_find_versiontags() {
	# scan for all datadirs
	openldap_datadirs=""
	if [ -f "${EROOT}"/etc/openldap/slapd.conf ]; then
		openldap_datadirs="$(awk '{if($1 == "directory") print $2 }' ${EROOT}/etc/openldap/slapd.conf)"
	fi
	openldap_datadirs="${openldap_datadirs} ${OPENLDAP_DEFAULTDIR_VERSIONTAG}"

	einfo
	einfo "Scanning datadir(s) from slapd.conf and"
	einfo "the default installdir for Versiontags"
	einfo "(${OPENLDAP_DEFAULTDIR_VERSIONTAG} may appear twice)"
	einfo

	# scan datadirs if we have a version tag
	openldap_found_tag=0
	have_files=0
	for each in ${openldap_datadirs}; do
		CURRENT_TAGDIR=${ROOT}`echo ${each} | sed "s:\/::"`
		CURRENT_TAG=${CURRENT_TAGDIR}/${OPENLDAP_VERSIONTAG}
		if [ -d ${CURRENT_TAGDIR} ] &&	[ ${openldap_found_tag} == 0 ] ; then
			einfo "- Checking ${each}..."
			if [ -r ${CURRENT_TAG} ] ; then
				# yey, we have one :)
				einfo "   Found Versiontag in ${each}"
				source ${CURRENT_TAG}
				if [ "${OLDPF}" == "" ] ; then
					eerror "Invalid Versiontag found in ${CURRENT_TAGDIR}"
					eerror "Please delete it"
					eerror
					die "Please kill the invalid versiontag in ${CURRENT_TAGDIR}"
				fi

				OLD_MAJOR=`get_version_component_range 2-3 ${OLDPF}`

				[ $(openldap_filecount ${CURRENT_TAGDIR}) -gt 0 ] && have_files=1

				# are we on the same branch?
				if [ "${OLD_MAJOR}" != "${PV:0:3}" ] ; then
					ewarn "   Versiontag doesn't match current major release!"
					if [[ "${have_files}" == "1" ]] ; then
						eerror "   Versiontag says other major and you (probably) have datafiles!"
						echo
						openldap_upgrade_howto
					else
						einfo "   No real problem, seems there's no database."
					fi
				else
					einfo "   Versiontag is fine here :)"
				fi
			else
				einfo "   Non-tagged dir ${each}"
				[ $(openldap_filecount ${each}) -gt 0 ] && have_files=1
				if [[ "${have_files}" == "1" ]] ; then
					einfo "   EEK! Non-empty non-tagged datadir, counting `ls -a ${each} | wc -l` files"
					echo

					eerror
					eerror "Your OpenLDAP Installation has a non tagged datadir that"
					eerror "possibly contains a database at ${CURRENT_TAGDIR}"
					eerror
					eerror "Please export data if any entered and empty or remove"
					eerror "the directory, installation has been stopped so you"
					eerror "can take required action"
					eerror
					eerror "For a HOWTO on exporting the data, see instructions in the ebuild"
					eerror
					openldap_upgrade_howto
					die "Please move the datadir ${CURRENT_TAGDIR} away"
				fi
			fi
			einfo
		fi
	done
	[ "${have_files}" == "1" ] && einfo "DB files present" || einfo "No DB files present"

	# Now we must check for the major version of sys-libs/db linked against.
	SLAPD_PATH=${EROOT}/usr/$(get_libdir)/openldap/slapd
	if [ "${have_files}" == "1" -a -f "${SLAPD_PATH}" ]; then
		OLDVER="$(/usr/bin/ldd ${SLAPD_PATH} \
			| awk '/libdb-/{gsub("^libdb-","",$1);gsub(".so$","",$1);print $1}')"
		if use berkdb; then
			# find which one would be used
			for bdb_slot in $BDB_SLOTS ; do
				NEWVER="$(db_findver "=sys-libs/db-${bdb_slot}*")"
				[[ -n "$NEWVER" ]] && break
			done
		fi
		local fail=0
		if [ -z "${OLDVER}" -a -z "${NEWVER}" ]; then
			:
			# Nothing wrong here.
		elif [ -z "${OLDVER}" -a -n "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was not built against"
			eerror "	any version of sys-libs/db, but the new one will build"
			eerror "	against	${NEWVER} and your database may be inaccessible."
			echo
			fail=1
		elif [ -n "${OLDVER}" -a -z "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will not be"
			eerror "	built against any version and your database may be"
			eerror "	inaccessible."
			echo
			fail=1
		elif [ "${OLDVER}" != "${NEWVER}" ]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will build against"
			eerror "	${NEWVER} and your database would be inaccessible."
			echo
			fail=1
		fi
		[ "${fail}" == "1" ] && openldap_upgrade_howto
	fi

	echo
	einfo
	einfo "All datadirs are fine, proceeding with merge now..."
	einfo
}

openldap_upgrade_howto() {
	eerror
	eerror "A (possible old) installation of OpenLDAP was detected,"
	eerror "installation will not proceed for now."
	eerror
	eerror "As major version upgrades can corrupt your database,"
	eerror "you need to dump your database and re-create it afterwards."
	eerror
	eerror "Additionally, rebuilding against different major versions of the"
	eerror "sys-libs/db libraries will cause your database to be inaccessible."
	eerror ""
	d="$(date -u +%s)"
	l="/root/ldapdump.${d}"
	i="${l}.raw"
	eerror " 1. /etc/init.d/slurpd stop ; /etc/init.d/slapd stop"
	eerror " 2. slapcat -l ${i}"
	eerror " 3. egrep -v '^(entry|context)CSN:' <${i} >${l}"
	eerror " 4. mv /var/lib/openldap-data/ /var/lib/openldap-data-backup/"
	eerror " 5. emerge --update \=net-nds/${PF}"
	eerror " 6. etc-update, and ensure that you apply the changes"
	eerror " 7. slapadd -l ${l}"
	eerror " 8. chown ldap:ldap /var/lib/openldap-data/*"
	eerror " 9. /etc/init.d/slapd start"
	eerror "10. check that your data is intact."
	eerror "11. set up the new replication system."
	eerror
	if [ "${FORCE_UPGRADE}" != "1" ]; then
		die "You need to upgrade your database first"
	else
		eerror "You have the magical FORCE_UPGRADE=1 in place."
		eerror "Don't say you weren't warned about data loss."
	fi
}

pkg_setup() {
	if ! use sasl && use cxx ; then
		die "To build the ldapc++ library you must emerge openldap with sasl support"
	fi
	# Bug #322787
	if use minimal && ! has_version "net-nds/openldap" ; then
		einfo "No datadir scan needed, openldap not installed"
	elif use minimal && has_version "net-nds/openldap" && built_with_use net-nds/openldap minimal ; then
		einfo "Skipping scan for previous datadirs as requested by minimal useflag"
	else
		openldap_find_versiontags
	fi

	enewgroup ldap 439
	enewuser ldap 439 -1 /usr/$(get_libdir)/openldap ldap
}

src_prepare() {
	# ensure correct SLAPI path by default
	sed -i -e 's,\(#define LDAPI_SOCK\).*,\1 "'"${EPREFIX}"'/var/run/openldap/slapd.sock",' \
		"${S}"/include/ldap_defaults.h

	epatch "${FILESDIR}"/${PN}-2.4.17-gcc44.patch

	epatch \
		"${FILESDIR}"/${PN}-2.2.14-perlthreadsfix.patch \
		"${FILESDIR}"/${PN}-2.4.15-ppolicy.patch

	# bug #116045 - still present in 2.4.28
	epatch "${FILESDIR}"/${PN}-2.4.35-contrib-smbk5pwd.patch
	# bug #408077 - samba4
	epatch "${FILESDIR}"/${PN}-2.4.35-contrib-samba4.patch

	# bug #189817
	epatch "${FILESDIR}"/${PN}-2.4.11-libldap_r.patch

	# bug #233633
	epatch "${FILESDIR}"/${PN}-2.4.17-fix-lmpasswd-gnutls-symbols.patch

	# bug #281495
	epatch "${FILESDIR}"/${PN}-2.4.28-gnutls-gcrypt.patch

	# bug #294350
	epatch "${FILESDIR}"/${PN}-2.4.6-evolution-ntlm.patch

	# unbreak /bin/sh -> dash
	epatch "${FILESDIR}"/${PN}-2.4.28-fix-dash.patch

	# bug #420959
	epatch "${FILESDIR}"/${PN}-2.4.31-gcc47.patch

	# unbundle lmdb
	epatch "${FILESDIR}"/${PN}-2.4.42-mdb-unbundle.patch
	rm -rf "${S}"/libraries/liblmdb

	cd "${S}"/build || die
	einfo "Making sure upstream build strip does not do stripping too early"
	sed -i.orig \
		-e '/^STRIP/s,-s,,g' \
		top.mk || die "Failed to block stripping"

	# wrong assumption that /bin/sh is /bin/bash
	sed -i \
		-e 's|/bin/sh|/bin/bash|g' \
		"${S}"/tests/scripts/* || die "sed failed"

	cd "${S}" || die

	AT_NOEAUTOMAKE=yes eautoreconf
}

build_contrib_module() {
	# <dir> <sources> <outputname>
	cd "${S}/contrib/slapd-modules/$1" || die
	einfo "Compiling contrib-module: $3"
	# Make sure it's uppercase
	local define_name="$(echo "SLAPD_OVER_${1}" | LC_ALL=C tr '[:lower:]' '[:upper:]')"
	"${lt}" --mode=compile --tag=CC \
		"${CC}" \
		-D${define_name}=SLAPD_MOD_DYNAMIC \
		-I"${BUILD_DIR}"/include \
		-I../../../include -I../../../servers/slapd ${CFLAGS} \
		-o ${2%.c}.lo -c $2 || die "compiling $3 failed"
	einfo "Linking contrib-module: $3"
	"${lt}" --mode=link --tag=CC \
		"${CC}" -module \
		${CFLAGS} \
		${LDFLAGS} \
		-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
		-o $3.la ${2%.c}.lo || die "linking $3 failed"
}

src_configure() {
	# Bug 408001
	use elibc_FreeBSD && append-cppflags -DMDB_DSYNC=O_SYNC -DMDB_FDATASYNC=fsync

	# connectionless ldap per bug #342439
	append-cppflags -DLDAP_CONNECTIONLESS

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=()

	use debug && myconf+=( $(use_enable debug) )

	# ICU usage is not configurable
	export ac_cv_header_unicode_utypes_h="$(multilib_is_native_abi && use icu && echo yes || echo no)"

	if ! use minimal && multilib_is_native_abi; then
		local CPPFLAGS=${CPPFLAGS}

		# re-enable serverside overlay chains per bug #296567
		# see ldap docs chaper 12.3.1 for details
		myconf+=( --enable-ldap )

		# backends
		myconf+=( --enable-slapd )
		if use berkdb ; then
			einfo "Using Berkeley DB for local backend"
			myconf+=( --enable-bdb --enable-hdb )
			DBINCLUDE=$(db_includedir $BDB_SLOTS)
			einfo "Using $DBINCLUDE for sys-libs/db version"
			# We need to include the slotted db.h dir for FreeBSD
			append-cppflags -I${DBINCLUDE}
		else
			myconf+=( --disable-bdb --disable-hdb )
		fi
		for backend in dnssrv ldap mdb meta monitor null passwd relay shell sock; do
			myconf+=( --enable-${backend}=mod )
		done

		myconf+=( $(use_enable perl perl mod) )

		myconf+=( $(use_enable odbc sql mod) )
		if use odbc ; then
			local odbc_lib="unixodbc"
			if use iodbc ; then
				odbc_lib="iodbc"
				append-cppflags -I"${EPREFIX}"/usr/include/iodbc
			fi
			myconf+=( --with-odbc=${odbc_lib} )
		fi

		# slapd options
		myconf+=(
			$(use_enable crypt)
			$(use_enable slp)
			$(use_enable samba lmpasswd)
			$(use_enable syslog)
		)
		if use experimental ; then
			myconf+=(
				--enable-dynacl
				--enable-aci=mod
			)
		fi
		for option in aci cleartext modules rewrite rlookups slapi; do
			myconf+=( --enable-${option} )
		done

		# slapd overlay options
		# Compile-in the syncprov, the others as module
		myconf+=( --enable-syncprov=yes )
		use overlays && myconf+=( --enable-overlays=mod )

	else
		myconf+=(
			--disable-backends
			--disable-slapd
			--disable-bdb
			--disable-hdb
			--disable-mdb
			--disable-overlays
			--disable-syslog
		)
	fi

	# basic functionality stuff
	myconf+=(
		$(use_enable ipv6)
		$(multilib_native_use_with sasl cyrus-sasl)
		$(multilib_native_use_enable sasl spasswd)
		$(use_enable tcpd wrappers)
	)

	local ssl_lib="no"
	if use ssl || ( ! use minimal && use samba ) ; then
		ssl_lib="openssl"
		use gnutls && ssl_lib="gnutls"
	fi

	myconf+=( --with-tls=${ssl_lib} )

	for basicflag in dynamic local proctitle shared; do
		myconf+=( --enable-${basicflag} )
	done

	tc-export AR CC CXX
	ECONF_SOURCE=${S} \
	STRIP=/bin/true \
	econf \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/openldap \
		$(use_enable static-libs static) \
		"${myconf[@]}"
	emake depend
}

src_configure_cxx() {
	# This needs the libraries built by the first build run.
	# So we have to run it AFTER the main build, not just after the main
	# configure.
	local myconf_ldapcpp=(
		--with-ldap-includes="${S}"/include
	)

	mkdir -p "${BUILD_DIR}"/contrib/ldapc++ || die
	cd "${BUILD_DIR}/contrib/ldapc++" || die

	local LDFLAGS=${LDFLAGS} CPPFLAGS=${CPPFLAGS}
	append-ldflags -L"${BUILD_DIR}"/libraries/liblber/.libs \
		-L"${BUILD_DIR}"/libraries/libldap/.libs
	append-cppflags -I"${BUILD_DIR}"/include
	ECONF_SOURCE=${S}/contrib/ldapc++ \
	econf "${myconf_ldapcpp[@]}" \
		CC="${CC}" \
		CXX="${CXX}"
}

multilib_src_compile() {
	tc-export AR CC CXX
	emake CC="${CC}" AR="${AR}" SHELL="${EPREFIX}"/bin/bash
	local lt="${BUILD_DIR}/libtool"
	export echo="echo"

	if ! use minimal && multilib_is_native_abi ; then
		if use cxx ; then
			einfo "Building contrib library: ldapc++"
			src_configure_cxx
			cd "${BUILD_DIR}/contrib/ldapc++" || die
			emake \
				CC="${CC}" CXX="${CXX}"
		fi

		if use smbkrb5passwd ; then
			einfo "Building contrib-module: smbk5pwd"
			cd "${S}/contrib/slapd-modules/smbk5pwd" || die

			MY_DEFS="-DDO_SHADOW"
			if use samba ; then
				MY_DEFS="${MY_DEFS} -DDO_SAMBA"
				MY_KRB5_INC=""
			fi
			if use kerberos ; then
				MY_DEFS="${MY_DEFS} -DDO_KRB5"
				MY_KRB5_INC="$(krb5-config --cflags)"
			fi

			emake \
				DEFS="${MY_DEFS}" \
				KRB5_INC="${MY_KRB5_INC}" \
				LDAP_BUILD="${BUILD_DIR}" \
				CC="${CC}" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap"
		fi

		if use overlays ; then
			einfo "Building contrib-module: samba4"
			cd "${S}/contrib/slapd-modules/samba4" || die

			emake \
				LDAP_BUILD="${BUILD_DIR}" \
				CC="${CC}" libexecdir="/usr/$(get_libdir)/openldap"
		fi

		if use kerberos ; then
			if use kinit ; then
				build_contrib_module "kinit" "kinit.c" "kinit"
			fi
			cd "${S}/contrib/slapd-modules/passwd" || die
			einfo "Compiling contrib-module: pw-kerberos"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I"${BUILD_DIR}"/include \
				-I../../../include \
				${CFLAGS} \
				$(krb5-config --cflags) \
				-DHAVE_KRB5 \
				-o kerberos.lo \
				-c kerberos.c || die "compiling pw-kerberos failed"
			einfo "Linking contrib-module: pw-kerberos"
			"${lt}" --mode=link --tag=CC \
				"${CC}" -module \
				${CFLAGS} \
				${LDFLAGS} \
				-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
				-o pw-kerberos.la \
				kerberos.lo || die "linking pw-kerberos failed"
		fi
		# We could build pw-radius if GNURadius would install radlib.h
		cd "${S}/contrib/slapd-modules/passwd" || die
		einfo "Compiling contrib-module: pw-netscape"
		"${lt}" --mode=compile --tag=CC \
			"${CC}" \
			-I"${BUILD_DIR}"/include \
			-I../../../include \
			${CFLAGS} \
			-o netscape.lo \
			-c netscape.c || die "compiling pw-netscape failed"
		einfo "Linking contrib-module: pw-netscape"
		"${lt}" --mode=link --tag=CC \
			"${CC}" -module \
			${CFLAGS} \
			${LDFLAGS} \
			-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
			-o pw-netscape.la \
			netscape.lo || die "linking pw-netscape failed"

		#build_contrib_module "acl" "posixgroup.c" "posixGroup" # example code only
		#build_contrib_module "acl" "gssacl.c" "gss" # example code only, also needs kerberos
		build_contrib_module "addpartial" "addpartial-overlay.c" "addpartial-overlay"
		build_contrib_module "allop" "allop.c" "overlay-allop"
		build_contrib_module "allowed" "allowed.c" "allowed"
		build_contrib_module "autogroup" "autogroup.c" "autogroup"
		build_contrib_module "cloak" "cloak.c" "cloak"
		# build_contrib_module "comp_match" "comp_match.c" "comp_match" # really complex, adds new external deps, questionable demand
		build_contrib_module "denyop" "denyop.c" "denyop-overlay"
		build_contrib_module "dsaschema" "dsaschema.c" "dsaschema-plugin"
		build_contrib_module "dupent" "dupent.c" "dupent"
		build_contrib_module "lastbind" "lastbind.c" "lastbind"
		# lastmod may not play well with other overlays
		build_contrib_module "lastmod" "lastmod.c" "lastmod"
		build_contrib_module "noopsrch" "noopsrch.c" "noopsrch"
		build_contrib_module "nops" "nops.c" "nops-overlay"
		#build_contrib_module "nssov" "nssov.c" "nssov-overlay" RESO:LATER
		build_contrib_module "trace" "trace.c" "trace"
		# build slapi-plugins
		cd "${S}/contrib/slapi-plugins/addrdnvalues" || die
		einfo "Building contrib-module: addrdnvalues plugin"
		"${CC}" -shared \
			-I"${BUILD_DIR}"/include \
			-I../../../include \
			${CFLAGS} \
			-fPIC \
			${LDFLAGS} \
			-o libaddrdnvalues-plugin.so \
			addrdnvalues.c || die "Building libaddrdnvalues-plugin.so failed"

	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		cd tests || die
		emake tests || die "make tests failed"
	fi
}

multilib_src_install() {
	local lt="${BUILD_DIR}/libtool"
	emake DESTDIR="${D}" SHELL="${EPREFIX}"/bin/bash install
	use static-libs || prune_libtool_files --all

	if ! use minimal && multilib_is_native_abi; then
		# openldap modules go here
		# TODO: write some code to populate slapd.conf with moduleload statements
		keepdir /usr/$(get_libdir)/openldap/openldap/

		# initial data storage dir
		keepdir /var/lib/openldap-data
		use prefix || fowners ldap:ldap /var/lib/openldap-data
		fperms 0700 /var/lib/openldap-data

		echo "OLDPF='${PF}'" > "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
		echo "# do NOT delete this. it is used"	>> "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
		echo "# to track versions for upgrading." >> "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"

		# use our config
		rm "${ED}"etc/openldap/slapd.conf
		insinto /etc/openldap
		newins "${FILESDIR}"/${PN}-2.4.40-slapd-conf slapd.conf
		configfile="${ED}"etc/openldap/slapd.conf

		# populate with built backends
		ebegin "populate config with built backends"
		for x in "${ED}"usr/$(get_libdir)/openldap/openldap/back_*.so; do
			einfo "Adding $(basename ${x})"
			sed -e "/###INSERTDYNAMICMODULESHERE###$/a# moduleload\t$(basename ${x})" -i "${configfile}"
		done
		sed -e "s:###INSERTDYNAMICMODULESHERE###$:# modulepath\t${EPREFIX}/usr/$(get_libdir)/openldap/openldap:" -i "${configfile}"
		use prefix || fowners root:ldap /etc/openldap/slapd.conf
		fperms 0640 /etc/openldap/slapd.conf
		cp "${configfile}" "${configfile}".default
		eend

		# install our own init scripts and systemd unit files
		einfo "Install init scripts"
		newinitd "${FILESDIR}"/slapd-initd-2.4.40-r2 slapd
		newconfd "${FILESDIR}"/slapd-confd-2.4.28-r1 slapd
		einfo "Install systemd service"
		systemd_dounit "${FILESDIR}"/slapd.service
		systemd_install_serviced "${FILESDIR}"/slapd.service.conf
		systemd_newtmpfilesd "${FILESDIR}"/slapd.tmpfilesd slapd.conf

		if [[ $(get_libdir) != lib ]]; then
			sed -e "s,/usr/lib/,/usr/$(get_libdir)/," -i \
				"${ED}"/etc/init.d/slapd \
				"${ED}"/usr/lib/systemd/system/slapd.service || die
		fi
		# If built without SLP, we don't need to be before avahi
		use slp \
			|| sed -i \
				-e '/before/{s/avahi-daemon//g}' \
				"${ED}"etc/init.d/slapd

		if use cxx ; then
			einfo "Install the ldapc++ library"
			cd "${BUILD_DIR}/contrib/ldapc++" || die
			emake DESTDIR="${D}" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" install
			cd "${S}"/contrib/ldapc++ || die
			newdoc README ldapc++-README
		fi

		if use smbkrb5passwd ; then
			einfo "Install the smbk5pwd module"
			cd "${S}/contrib/slapd-modules/smbk5pwd" || die
			emake DESTDIR="${D}" \
				LDAP_BUILD="${BUILD_DIR}" \
				libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" install
			newdoc README smbk5pwd-README
		fi

		if use overlays ; then
			einfo "Install the samba4 module"
			cd "${S}/contrib/slapd-modules/samba4" || die
			emake DESTDIR="${D}" \
				LDAP_BUILD="${BUILD_DIR}" \
				libexecdir="/usr/$(get_libdir)/openldap" install
			newdoc README samba4-README
		fi

		einfo "Installing contrib modules"
		cd "${S}/contrib/slapd-modules" || die
		for l in */*.la; do
			"${lt}" --mode=install cp ${l} \
				"${ED}"usr/$(get_libdir)/openldap/openldap || \
				die "installing ${l} failed"
		done

		dodoc "${FILESDIR}"/DB_CONFIG.fast.example
		docinto contrib
		doman */*.5
		#newdoc acl/README*
		newdoc addpartial/README addpartial-README
		newdoc allop/README allop-README
		newdoc allowed/README  allowed-README
		newdoc autogroup/README autogroup-README
		newdoc dsaschema/README dsaschema-README
		newdoc passwd/README passwd-README
		cd "${S}/contrib/slapi-plugins" || die
		insinto /usr/$(get_libdir)/openldap/openldap
		doins  */*.so
		docinto contrib
		newdoc addrdnvalues/README addrdnvalues-README

		insinto /etc/openldap/schema
		newins "${DISTDIR}"/${BIS_P} ${BIS_PN}

		docinto back-sock ; dodoc "${S}"/servers/slapd/back-sock/searchexample*
		docinto back-shell ; dodoc "${S}"/servers/slapd/back-shell/searchexample*
		docinto back-perl ; dodoc "${S}"/servers/slapd/back-perl/SampleLDAP.pm

		dosbin "${S}"/contrib/slapd-tools/statslog
		newdoc "${S}"/contrib/slapd-tools/README README.statslog
	fi
}

multilib_src_install_all() {
	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README
	docinto rfc ; dodoc doc/rfc/*.txt
}

pkg_preinst() {
	# keep old libs if any
	preserve_old_lib /usr/$(get_libdir)/{liblber,libldap_r,liblber}-2.3$(get_libname 0)
	# bug 440470, only display the getting started help there was no openldap before,
	# or we are going to a non-minimal build
	! has_version net-nds/openldap || has_version 'net-nds/openldap[minimal]'
	OPENLDAP_PRINT_MESSAGES=$((! $?))
}

pkg_postinst() {
	if ! use minimal ; then
		# You cannot build SSL certificates during src_install that will make
		# binary packages containing your SSL key, which is both a security risk
		# and a misconfiguration if multiple machines use the same key and cert.
		if use ssl; then
			install_cert /etc/openldap/ssl/ldap
			use prefix || chown ldap:ldap "${EROOT}"etc/openldap/ssl/ldap.*
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "add 'TLS_REQCERT allow' if you want to use them."
		fi

		if use prefix; then
			# Warn about prefix issues with slapd
			eerror "slapd might NOT be usable on Prefix systems as it requires root privileges"
			eerror "to start up, and requires that certain files directories be owned by"
			eerror "ldap:ldap.  As Prefix does not support changing ownership of files and"
			eerror "directories, you will have to manually fix this yourself."
		fi

		# These lines force the permissions of various content to be correct
		use prefix || chown ldap:ldap "${EROOT}"var/run/openldap
		chmod 0755 "${EROOT}"var/run/openldap
		use prefix || chown root:ldap "${EROOT}"etc/openldap/slapd.conf{,.default}
		chmod 0640 "${EROOT}"etc/openldap/slapd.conf{,.default}
		use prefix || chown ldap:ldap "${EROOT}"var/lib/openldap-data
	fi

	if has_version 'net-nds/openldap[-minimal]' && ((${OPENLDAP_PRINT_MESSAGES})); then
		elog "Getting started using OpenLDAP? There is some documentation available:"
		elog "Gentoo Guide to OpenLDAP Authentication"
		elog "(https://www.gentoo.org/doc/en/ldap-howto.xml)"
		elog "---"
		elog "An example file for tuning BDB backends with openldap is"
		elog "DB_CONFIG.fast.example in /usr/share/doc/${PF}/"
	fi

	preserve_old_lib_notify /usr/$(get_libdir)/{liblber,libldap,libldap_r}-2.3$(get_libname 0)
}
