# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Re cleanups:
# 2.5.x is an LTS release so we want to keep it for a while.

inherit autotools flag-o-matic multilib multilib-minimal preserve-libs ssl-cert toolchain-funcs systemd tmpfiles

MY_PV="$(ver_rs 1-2 _)"

BIS_PN=rfc2307bis.schema
BIS_PV=20140524
BIS_P="${BIS_PN}-${BIS_PV}"

DESCRIPTION="LDAP suite of application and development tools"
HOMEPAGE="https://www.openldap.org/"
SRC_URI="
	https://gitlab.com/openldap/${PN}/-/archive/OPENLDAP_REL_ENG_${MY_PV}/${PN}-OPENLDAP_REL_ENG_${MY_PV}.tar.bz2
	mirror://gentoo/${BIS_P}
"
S="${WORKDIR}"/${PN}-OPENLDAP_REL_ENG_${MY_PV}

LICENSE="OPENLDAP GPL-2"
# Subslot added for bug #835654
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE_DAEMON="argon2 +cleartext crypt experimental minimal samba tcpd"
IUSE_OVERLAY="overlays perl autoca"
IUSE_OPTIONAL="debug gnutls iodbc ipv6 odbc sasl ssl selinux static-libs +syslog test"
IUSE_CONTRIB="kerberos kinit pbkdf2 sha2 smbkrb5passwd"
IUSE_CONTRIB="${IUSE_CONTRIB} cxx"
IUSE="systemd ${IUSE_DAEMON} ${IUSE_BACKEND} ${IUSE_OVERLAY} ${IUSE_OPTIONAL} ${IUSE_CONTRIB}"
RESTRICT="!test? ( test )"

RESTRICT="!test? ( test )"
REQUIRED_USE="cxx? ( sasl )
	pbkdf2? ( ssl )
	test? ( cleartext sasl )
	autoca? ( !gnutls )
	?? ( test minimal )
	kerberos? ( ?? ( kinit smbkrb5passwd ) )"

SYSTEM_LMDB_VER=0.9.30
# openssl is needed to generate lanman-passwords required by samba
COMMON_DEPEND="
	kernel_linux? ( sys-apps/util-linux )
	ssl? (
		!gnutls? (
			>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
		)
		gnutls? (
			>=net-libs/gnutls-2.12.23-r6:=[${MULTILIB_USEDEP}]
			>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
		)
	)
	sasl? ( dev-libs/cyrus-sasl:= )
	!minimal? (
		dev-libs/libltdl
		sys-fs/e2fsprogs
		>=dev-db/lmdb-${SYSTEM_LMDB_VER}:=
		argon2? ( app-crypt/argon2:= )
		crypt? ( virtual/libcrypt:= )
		tcpd? ( sys-apps/tcp-wrappers )
		odbc? ( !iodbc? ( dev-db/unixODBC )
			iodbc? ( dev-db/libiodbc ) )
		perl? ( dev-lang/perl:=[-build(-)] )
		samba? (
			dev-libs/openssl:0=
		)
		smbkrb5passwd? (
			dev-libs/openssl:0=
			kerberos? ( app-crypt/heimdal )
		)
		kerberos? (
			virtual/krb5
			kinit? ( !app-crypt/heimdal )
		)
	)
"
DEPEND="${COMMON_DEPEND}
	sys-apps/groff
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-ldap )
"

# The user/group are only used for running daemons which are
# disabled in minimal builds, so elide the accounts too.
BDEPEND="!minimal? (
		acct-group/ldap
		acct-user/ldap
)
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

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.28-fix-dash.patch
	"${FILESDIR}"/${PN}-2.6.1-system-mdb.patch
	"${FILESDIR}"/${PN}-2.6.1-cloak.patch
	"${FILESDIR}"/${PN}-2.6.1-flags.patch
	"${FILESDIR}"/${PN}-2.6.1-fix-missing-mapping.patch
	"${FILESDIR}"/${PN}-2.6.4-clang16.patch
	"${FILESDIR}"/${PN}-2.6.4-libressl.patch #903001
)

openldap_filecount() {
	local dir="$1"
	find "${dir}" -type f ! -name '.*' ! -name 'DB_CONFIG*' | wc -l
}

openldap_find_versiontags() {
	# scan for all datadirs
	local openldap_datadirs=()
	if [[ -f "${EROOT}"/etc/openldap/slapd.conf ]]; then
		openldap_datadirs=( $(awk '{if($1 == "directory") print $2 }' "${EROOT}"/etc/openldap/slapd.conf) )
	fi
	openldap_datadirs+=( ${OPENLDAP_DEFAULTDIR_VERSIONTAG} )

	einfo
	einfo "Scanning datadir(s) from slapd.conf and"
	einfo "the default installdir for Versiontags"
	einfo "(${OPENLDAP_DEFAULTDIR_VERSIONTAG} may appear twice)"
	einfo

	# scan datadirs if we have a version tag
	openldap_found_tag=0
	have_files=0
	for each in ${openldap_datadirs[@]} ; do
		CURRENT_TAGDIR="${EROOT}$(sed "s:\/::" <<< ${each})"
		CURRENT_TAG="${CURRENT_TAGDIR}/${OPENLDAP_VERSIONTAG}"
		if [[ -d "${CURRENT_TAGDIR}" ]] && [[ "${openldap_found_tag}" == 0 ]] ; then
			einfo "- Checking ${each}..."
			if [[ -r "${CURRENT_TAG}" ]] ; then
				# yey, we have one :)
				einfo "   Found Versiontag in ${each}"
				source "${CURRENT_TAG}"
				if [[ "${OLDPF}" == "" ]] ; then
					eerror "Invalid Versiontag found in ${CURRENT_TAGDIR}"
					eerror "Please delete it"
					eerror
					die "Please kill the invalid versiontag in ${CURRENT_TAGDIR}"
				fi

				OLD_MAJOR=$(ver_cut 2-3 ${OLDPF})

				[[ "$(openldap_filecount ${CURRENT_TAGDIR})" -gt 0 ]] && have_files=1

				# are we on the same branch?
				if [[ "${OLD_MAJOR}" != "${PV:0:3}" ]] ; then
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
				[[ "$(openldap_filecount ${each})" -gt 0 ]] && have_files=1
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
	[[ "${have_files}" == "1" ]] && einfo "DB files present" || einfo "No DB files present"

	# Now we must check for the major version of sys-libs/db linked against.
	# TODO: remove this as we dropped bdb support (gone upstream) in 2.6.1?
	SLAPD_PATH="${EROOT}/usr/$(get_libdir)/openldap/slapd"
	if [[ "${have_files}" == "1" ]] && [[ -f "${SLAPD_PATH}" ]]; then
		OLDVER="$(/usr/bin/ldd ${SLAPD_PATH} \
			| awk '/libdb-/{gsub("^libdb-","",$1);gsub(".so$","",$1);print $1}')"
		local fail=0

		# This will not cover detection of cn=Config based configuration, but
		# it's hopefully good enough.
		if grep -sq '^backend.*shell' "${EROOT}"/etc/openldap/slapd.conf; then
			eerror "    OpenLDAP >= 2.5.x has dropped support for Shell backend."
			eerror "	You will need to migrate per upstream's migration notes"
			eerror "	at https://www.openldap.org/doc/admin25/appendix-upgrading.html."
			eerror "	Your existing database will not be accessible until it is"
			eerror "	converted away from backend shell!"
			echo
			fail=1
		fi
		if has_version "${CATEGORY}/${PN}[berkdb]" || grep -sq '^backend.*(bdb|hdb)' /etc/openldap/slapd.conf; then
			eerror "	OpenLDAP >= 2.5.x has dropped support for Berkeley DB."
			eerror "	You will need to migrate per upstream's migration notes"
			eerror "	at https://www.openldap.org/doc/admin25/appendix-upgrading.html."
			eerror "	Your existing database will not be accessible until it is"
			eerror "	converted to mdb!"
			echo
			fail=1
		elif [[ -z "${OLDVER}" ]] && [[ -z "${NEWVER}" ]]; then
			:
			# Nothing wrong here.
		elif [[ -z "${OLDVER}" ]] && [[ -n "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was not built against"
			eerror "	any version of sys-libs/db, but the new one will build"
			eerror "	against	${NEWVER} and your database may be inaccessible."
			echo
			fail=1
		elif [[ -n "${OLDVER}" ]] && [[ -z "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will not be"
			eerror "	built against any version and your database may be"
			eerror "	inaccessible."
			echo
			fail=1
		elif [[ "${OLDVER}" != "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will build against"
			eerror "	${NEWVER} and your database would be inaccessible."
			echo
			fail=1
		fi
		[[ "${fail}" == "1" ]] && openldap_upgrade_howto
	fi

	echo
	einfo
	einfo "All datadirs are fine, proceeding with merge now..."
	einfo
}

openldap_upgrade_howto() {
	local d l i
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
	eerror " 1. /etc/init.d/slapd stop"
	eerror " 2. slapcat -l ${i}"
	eerror " 3. grep -E -v '^(entry|context)CSN:' <${i} >${l}"
	eerror " 4. mv /var/lib/openldap-data/ /var/lib/openldap-data-backup/"
	eerror " 5. emerge --update \=net-nds/${PF}"
	eerror " 6. etc-update, and ensure that you apply the changes"
	eerror " 7. slapadd -l ${l}"
	eerror " 8. chown ldap:ldap /var/lib/openldap-data/*"
	eerror " 9. /etc/init.d/slapd start"
	eerror "10. Check that your data is intact."
	eerror "11. Set up the new replication system."
	eerror
	if [[ "${FORCE_UPGRADE}" != "1" ]]; then
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
	elif use minimal && has_version 'net-nds/openldap[minimal]' ; then
		einfo "Skipping scan for previous datadirs as requested by minimal useflag"
	else
		openldap_find_versiontags
	fi
}

src_prepare() {
	# The system copy of dev-db/lmdb must match the version that this copy
	# of OpenLDAP shipped with! See bug #588792.
	#
	# Fish out MDB_VERSION_MAJOR/MDB_VERSION_MINOR/MDB_VERSION_PATCH from
	# the bundled lmdb's header to find out the version.
	local bundled_lmdb_version=$(sed -En '/^#define MDB_VERSION_(MAJOR|MINOR|PATCH)(\s+)?/{s/[^0-9.]//gp}' libraries/liblmdb/lmdb.h || die)
	printf -v bundled_lmdb_version "%s." ${bundled_lmdb_version}

	if [[ ${SYSTEM_LMDB_VER}. != ${bundled_lmdb_version} ]] ; then
		eerror "Source lmdb version: ${bundled_lmdb_version}"
		eerror "Ebuild lmdb version: ${SYSTEM_LMDB_VER}"
		die "Ebuild needs to update SYSTEM_LMDB_VER!"
	fi

	rm -r libraries/liblmdb || die 'could not removed bundled lmdb directory'

	local filename
	for filename in doc/drafts/draft-ietf-ldapext-acl-model-xx.txt; do
		iconv -f iso-8859-1 -t utf-8 "${filename}" > "${filename}.utf8"
		mv "${filename}.utf8" "${filename}"
	done

	default

	sed -i \
		-e "s:\$(localstatedir)/run:${EPREFIX}/run:" \
		-e '/MKDIR.*.(DESTDIR)\/run/d' \
		-e '/MKDIR.*.(DESTDIR).*.(runstatedir)/d' \
		servers/slapd/Makefile.in || die 'adjusting slapd Makefile.in failed'

	pushd build &>/dev/null || die "pushd build"
	einfo "Making sure upstream build strip does not do stripping too early"
	sed -i.orig \
		-e '/^STRIP/s,-s,,g' \
		top.mk || die "Failed to remove too early stripping"
	popd &>/dev/null || die

	# Fails with OpenSSL 3, bug #848894
	# https://bugs.openldap.org/show_bug.cgi?id=10009
	rm tests/scripts/test076-authid-rewrite || die

	eautoreconf
	multilib_copy_sources
}

build_contrib_module() {
	# <dir> [<target>]
	pushd "${S}/contrib/slapd-modules/$1" &>/dev/null || die "pushd contrib/slapd-modules/$1"
	einfo "Compiling contrib-module: $1"
	local target="${2:-all}"
	emake \
		LDAP_BUILD="${BUILD_DIR}" prefix="${EPREFIX}/usr" \
		CC="${CC}" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" \
		"${target}"
	popd &>/dev/null || die
}

multilib_src_configure() {
	# Optional Features
	myconf+=(
		--enable-option-checking
		$(use_enable debug)
		--enable-dynamic
		$(use_enable syslog)
		$(use_enable ipv6)
		--enable-local
	)

	# Optional Packages
	myconf+=(
		--without-fetch
	)

	if use experimental ; then
		# connectionless ldap per bug #342439
		# connectionless is a unsupported feature according to Howard Chu
		# see https://bugs.openldap.org/show_bug.cgi?id=9739
		# (see also bug #892009)
		append-flags -DLDAP_CONNECTIONLESS
	fi

	if ! use minimal && multilib_is_native_abi; then
		# SLAPD (Standalone LDAP Daemon) Options
		# overlay chaining requires '--enable-ldap' #296567
		# see https://www.openldap.org/doc/admin26/overlays.html#Chaining
		myconf+=(
			--enable-ldap=yes
			--enable-slapd
			$(use_enable cleartext)
			$(use_enable crypt)
			$(multilib_native_use_enable sasl spasswd)
			--disable-slp
			$(use_enable tcpd wrappers)
		)
		if use experimental ; then
			myconf+=(
				--enable-dynacl
				# ACI build as dynamic module not supported (yet)
				--enable-aci=yes
			)
		fi

		for option in modules rlookups slapi; do
			myconf+=( --enable-${option} )
		done

		# static SLAPD backends
		for backend in mdb; do
			myconf+=( --enable-${backend}=yes )
		done

		# module SLAPD backends
		for backend in asyncmeta dnssrv meta null passwd relay sock; do
			# missing modules: wiredtiger (not available in portage)
			myconf+=( --enable-${backend}=mod )
		done

		use perl && myconf+=( --enable-perl=mod )

		if use odbc ; then
			myconf+=( --enable-sql=mod )
			if use iodbc ; then
				myconf+=( --with-odbc="iodbc" )
				append-cflags -I"${EPREFIX}"/usr/include/iodbc
			else
				myconf+=( --with-odbc="unixodbc" )
			fi
		fi

		use overlays && myconf+=( --enable-overlays=mod )
		use autoca && myconf+=( --enable-autoca=mod ) || myconf+=( --enable-autoca=no )
		# compile-in the syncprov
		myconf+=( --enable-syncprov=yes )

		# SLAPD Password Module Options
		myconf+=(
			$(use_enable argon2)
		)

		# Optional Packages
		myconf+=(
			$(use_with systemd)
			$(multilib_native_use_with sasl cyrus-sasl)
		)
	else
		myconf+=(
			--disable-backends
			--disable-slapd
			--disable-mdb
			--disable-overlays
			--disable-autoca
			--disable-syslog
			--without-systemd
		)
	fi

	# Library Generation & Linking Options
	myconf+=(
		$(use_enable static-libs static)
		--enable-shared
		--enable-versioning
		--with-pic
	)

	# some cross-compiling tests don't pan out well.
	tc-is-cross-compiler && myconf+=(
		--with-yielding-select=yes
	)

	local ssl_lib="no"
	if use ssl || ( ! use minimal && use samba ) ; then
		if use gnutls ; then
			myconf+=( --with-tls="gnutls" )
		else
			# disable MD2 hash function
			append-cflags -DOPENSSL_NO_MD2
			myconf+=( --with-tls="openssl" )
		fi
	else
		myconf+=( --with-tls="no" )
	fi

	tc-export AR CC CXX

	ECONF_SOURCE="${S}" econf \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/openldap \
		--localstatedir="${EPREFIX}"/var \
		--runstatedir="${EPREFIX}"/run \
		--sharedstatedir="${EPREFIX}"/var/lib \
		"${myconf[@]}"

	# argument '--runstatedir' seems to have no effect therefore this workaround
	sed -i \
		-e 's:^runstatedir=.*:runstatedir=${EPREFIX}/run:' \
		configure contrib/ldapc++/configure contrib/ldaptcl/configure || die 'could not set runstatedir'

	sed -i \
		-e "s:/var/run/sasl2/mux:${EPREFIX}/run/sasl2/mux:" \
		doc/guide/admin/security.sdf || die 'could not fix run path in doc'

	emake depend
}

src_configure_cxx() {
	# This needs the libraries built by the first build run.
	# we have to run it AFTER the main build, not just after the main configure
	local myconf_ldapcpp=(
		--with-libldap="${E}/lib"
		--with-ldap-includes="${S}/include"
	)

	mkdir -p "${BUILD_DIR}"/contrib/ldapc++ || die "could not create ${BUILD_DIR}/contrib/ldapc++ directory"
	pushd "${BUILD_DIR}/contrib/ldapc++" &>/dev/null || die "pushd contrib/ldapc++"

	local LDFLAGS="${LDFLAGS}"
	local CPPFLAGS="${CPPFLAGS}"

	append-ldflags -L"${BUILD_DIR}"/libraries/liblber/.libs -L"${BUILD_DIR}"/libraries/libldap/.libs
	append-cppflags -I"${BUILD_DIR}"/include

	ECONF_SOURCE="${S}"/contrib/ldapc++ econf "${myconf_ldapcpp[@]}"
	popd &>/dev/null || die "popd contrib/ldapc++"
}

multilib_src_compile() {
	tc-export AR CC CXX
	emake CC="$(tc-getCC)" SHELL="${EPREFIX}"/bin/sh

	if ! use minimal && multilib_is_native_abi ; then
		if use cxx ; then
			einfo "Building contrib library: ldapc++"
			src_configure_cxx
			pushd "${BUILD_DIR}/contrib/ldapc++" &>/dev/null || die "pushd contrib/ldapc++"
			emake
			popd &>/dev/null || die
		fi

		if use smbkrb5passwd ; then
			einfo "Building contrib-module: smbk5pwd"
			pushd "${S}/contrib/slapd-modules/smbk5pwd" &>/dev/null || die "pushd contrib/slapd-modules/smbk5pwd"

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
				libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap"
			popd &>/dev/null || die
		fi

		if use overlays ; then
			einfo "Building contrib-module: samba4"
			pushd "${S}/contrib/slapd-modules/samba4" &>/dev/null || die "pushd contrib/slapd-modules/samba4"

			emake \
				LDAP_BUILD="${BUILD_DIR}" \
				CC="$(tc-getCC)" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap"
			popd &>/dev/null || die
		fi

		if use kerberos ; then
			if use kinit ; then
				build_contrib_module "kinit" "kinit.c" "kinit"
			fi
			build_contrib_module "passwd" "pw-kerberos.la"
		fi

		if use pbkdf2; then
			build_contrib_module "passwd/pbkdf2"
		fi

		if use sha2 ; then
			build_contrib_module "passwd/sha2"
		fi

		# We could build pw-radius if GNURadius would install radlib.h
		build_contrib_module "passwd" "pw-netscape.la"

		#build_contrib_module "acl" "posixgroup.la" # example code only
		#build_contrib_module "acl" "gssacl.la" # example code only, also needs kerberos
		build_contrib_module "addpartial"
		build_contrib_module "allop"
		build_contrib_module "allowed"
		build_contrib_module "autogroup"
		build_contrib_module "cloak"
		# build_contrib_module "comp_match" # really complex, adds new external deps, questionable demand
		build_contrib_module "denyop"
		build_contrib_module "dsaschema"
		build_contrib_module "dupent"
		build_contrib_module "lastbind"
		# lastmod may not play well with other overlays
		build_contrib_module "lastmod"
		build_contrib_module "noopsrch"
		#build_contrib_module "nops" https://bugs.gentoo.org/641576
		#build_contrib_module "nssov" RESO:LATER
		build_contrib_module "trace"
		# build slapi-plugins
		pushd "${S}/contrib/slapi-plugins/addrdnvalues" &>/dev/null || die "pushd contrib/slapi-plugins/addrdnvalues"
		einfo "Building contrib-module: addrdnvalues plugin"
		$(tc-getCC) -shared \
			-I"${BUILD_DIR}"/include \
			-I../../../include \
			${CPPFLAGS} \
			${CFLAGS} \
			-fPIC \
			${LDFLAGS} \
			-o libaddrdnvalues-plugin.so \
			addrdnvalues.c || die "Building libaddrdnvalues-plugin.so failed"
		popd &>/dev/null || die
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		cd tests || die
		pwd

		# Increase various test timeouts/delays, bug #894012
		# We can't just double everything as there's a cumulative effect.
		export SLEEP0=2 # originally 1
		export SLEEP1=10 # originally 7
		export SLEEP2=20 # originally 15
		export TIMEOUT=16 # originally 8

		# emake test => runs only lloadd & mdb, in serial; skips ldif,sql,wt,regression
		# emake partests => runs ALL of the tests in parallel
		# wt/WiredTiger is not supported in Gentoo
		TESTS=( plloadd pmdb )
		#TESTS+=( pldif ) # not done by default, so also exclude here
		#use odbc && TESTS+=( psql ) # not done by default, so also exclude here

		emake "${TESTS[@]}"
	fi
}

multilib_src_install() {
	emake CC="$(tc-getCC)" \
		DESTDIR="${D}" SHELL="${EPREFIX}"/bin/sh install

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
		rm "${ED}"/etc/openldap/slapd.conf
		insinto /etc/openldap
		newins "${FILESDIR}"/${PN}-2.6.3-slapd-conf slapd.conf
		configfile="${ED}"/etc/openldap/slapd.conf

		# populate with built backends
		einfo "populate config with built backends"
		for x in "${ED}"/usr/$(get_libdir)/openldap/openldap/back_*.so; do
			einfo "Adding $(basename ${x})"
			sed -e "/###INSERTDYNAMICMODULESHERE###$/a# moduleload\t$(basename ${x})" -i "${configfile}" || die
		done
		sed -e "s:###INSERTDYNAMICMODULESHERE###$:# modulepath\t${EPREFIX}/usr/$(get_libdir)/openldap/openldap:" -i "${configfile}"
		use prefix || fowners root:ldap /etc/openldap/slapd.conf
		fperms 0640 /etc/openldap/slapd.conf
		cp "${configfile}" "${configfile}".default || die

		# install our own init scripts and systemd unit files
		einfo "Install init scripts"
		sed -e "s,/usr/lib/,/usr/$(get_libdir)/," "${FILESDIR}"/slapd-initd-2.4.40-r2 > "${T}"/slapd || die
		doinitd "${T}"/slapd
		newconfd "${FILESDIR}"/slapd-confd-2.6.1 slapd

		if use systemd; then
			# The systemd unit uses Type=notify, so it is useless without USE=systemd
			einfo "Install systemd service"
			rm -rf "${ED}"/{,usr/}lib/systemd
			sed -e "s,/usr/lib/,/usr/$(get_libdir)/," "${FILESDIR}"/slapd-2.6.1.service > "${T}"/slapd.service || die
			systemd_dounit "${T}"/slapd.service
			systemd_install_serviced "${FILESDIR}"/slapd.service.conf
			newtmpfiles "${FILESDIR}"/slapd.tmpfilesd slapd.conf
		fi

		# if built without SLP, we don't need to be before avahi
			sed -i \
				-e '/before/{s/avahi-daemon//g}' \
				"${ED}"/etc/init.d/slapd \
				|| die

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
				libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" install
			newdoc README samba4-README
		fi

		einfo "Installing contrib modules"
		cd "${S}/contrib/slapd-modules" || die
		for l in */*.la */*/*.la; do
			[[ -e ${l} ]] || continue
			libtool --mode=install cp ${l} \
				"${ED}"/usr/$(get_libdir)/openldap/openldap || \
				die "installing ${l} failed"
		done

		dodoc "${FILESDIR}"/DB_CONFIG.fast.example
		docinto contrib
		doman */*.5
		#newdoc acl/README*
		newdoc addpartial/README addpartial-README
		newdoc allop/README allop-README
		newdoc allowed/README allowed-README
		newdoc autogroup/README autogroup-README
		newdoc dsaschema/README dsaschema-README
		newdoc passwd/README passwd-README
		cd "${S}/contrib/slapi-plugins" || die
		insinto /usr/$(get_libdir)/openldap/openldap
		doins */*.so
		docinto contrib
		newdoc addrdnvalues/README addrdnvalues-README

		insinto /etc/openldap/schema
		newins "${DISTDIR}"/${BIS_P} ${BIS_PN}

		docinto back-sock ; dodoc "${S}"/servers/slapd/back-sock/searchexample*
		docinto back-perl ; dodoc "${S}"/servers/slapd/back-perl/SampleLDAP.pm

		dosbin "${S}"/contrib/slapd-tools/statslog
		newdoc "${S}"/contrib/slapd-tools/README README.statslog
	fi

	if ! use static-libs ; then
		find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
	fi
}

multilib_src_install_all() {
	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README
	docinto rfc ; dodoc doc/rfc/*.txt
}

pkg_preinst() {
	# keep old libs if any
	preserve_old_lib /usr/$(get_libdir)/{liblber,libldap,libldap_r}-2.4$(get_libname 0)
	# bug 440470, only display the getting started help there was no openldap before,
	# or we are going to a non-minimal build
	! has_version net-nds/openldap || has_version 'net-nds/openldap[minimal]'
	OPENLDAP_PRINT_MESSAGES=$((! $?))
}

pkg_postinst() {
	if ! use minimal ; then
		if use systemd; then
			tmpfiles_process slapd.conf
		fi

		# You cannot build SSL certificates during src_install that will make
		# binary packages containing your SSL key, which is both a security risk
		# and a misconfiguration if multiple machines use the same key and cert.
		if use ssl; then
			install_cert /etc/openldap/ssl/ldap
			use prefix || chown ldap:ldap "${EROOT}"/etc/openldap/ssl/ldap.*
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
		if [[ -d "${EROOT}"/var/run/openldap ]]; then
			use prefix || { chown ldap:ldap "${EROOT}"/var/run/openldap || die; }
			chmod 0755 "${EROOT}"/var/run/openldap || die
		fi
		use prefix || chown root:ldap "${EROOT}"/etc/openldap/slapd.conf{,.default}
		chmod 0640 "${EROOT}"/etc/openldap/slapd.conf{,.default} || die
		use prefix || chown ldap:ldap "${EROOT}"/var/lib/openldap-data
	fi

	if has_version 'net-nds/openldap[-minimal]' && ((${OPENLDAP_PRINT_MESSAGES})); then
		elog "Getting started using OpenLDAP? There is some documentation available:"
		elog "Gentoo Guide to OpenLDAP Authentication"
		elog "(https://wiki.gentoo.org/wiki/Centralized_authentication_using_OpenLDAP)"
	fi

	preserve_old_lib_notify /usr/$(get_libdir)/{liblber,libldap,libldap_r}-2.4$(get_libname 0)
}
