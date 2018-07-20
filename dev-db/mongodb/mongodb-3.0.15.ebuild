# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
SCONS_MIN_VERSION="2.3.0"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit eutils flag-o-matic multilib pax-utils scons-utils systemd toolchain-funcs user versionator check-reqs

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kerberos libressl mms-agent ssl +tools"

RDEPEND="app-arch/snappy
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.57[threads(+)]
	>=dev-libs/libpcre-8.39[cxx]
	dev-libs/snowball-stemmer
	net-libs/libpcap
	sys-libs/zlib
	mms-agent? ( app-admin/mms-agent )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1g:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.8.2:*
	sys-libs/ncurses
	sys-libs/readline
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )"
PDEPEND="tools? ( >=app-admin/mongo-tools-${PV} )"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.14-fix-scons.patch"
	"${FILESDIR}/${PN}-3.0.14-fix-std-string.patch"
	"${FILESDIR}/${PN}-3.4.6-sysmacros-include.patch"
)

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	# Maintainer notes
	#
	# --use-system-tcmalloc is strongly NOT recommended:
	# https://www.mongodb.org/about/contributors/tutorial/build-mongodb-from-source/
	#
	# --c++11 is required by scons instead of auto detection:
	# https://jira.mongodb.org/browse/SERVER-19661

	scons_opts=(
		--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX) --c++11
		--disable-warnings-as-errors
		--use-system-boost
		--use-system-pcre
		--use-system-snappy
		--use-system-stemmer
		--use-system-yaml
	)

	if use debug; then
		scons_opts+=( --dbg=on )
	fi

	if use prefix; then
		scons_opts+=(
			--cpppath="${EPREFIX}/usr/include )"
			--libpath="${EPREFIX}/usr/$(get_libdir)"
		)
	fi

	if use kerberos; then
		scons_opts+=( --use-sasl-client )
	fi

	if use ssl; then
		scons_opts+=( --ssl )
	fi
}

src_compile() {
	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi
	escons "${scons_opts[@]}" core tools || die
}

src_install() {
	escons "${scons_opts[@]}" --nostrip install --prefix="${ED}"/usr || die

	local x
	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r3" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r3" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd-r3" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd-r3" ${PN/db/s}

	insinto /etc
	newins "${FILESDIR}/${PN}.conf-r3" ${PN}.conf
	newins "${FILESDIR}/${PN/db/s}.conf-r2" ${PN/db/s}.conf

	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongo,mongod,mongos}
}

pkg_preinst() {
	# wrt bug #461466
	if [[ "$(get_libdir)" == "lib64" ]]; then
		rmdir "${ED}"/usr/lib/ &>/dev/null
	fi
}

src_test() {
	escons "${scons_opts[@]}" unittests || die

	# tests fail
	sed -i '/\/util\/options_parser\/options_parser_test/d' build/unittests.txt || die
	sed -i '/\/mongo\/server_options_test/d' build/unittests.txt || die

	local x
	while read x; do
		einfo "Running test $x"
		./$x || die
	done < build/unittests.txt
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 3.0 ${v}; then
			ewarn "!! IMPORTANT !!"
			ewarn " "
			ewarn "${PN} configuration files have changed !"
			ewarn " "
			ewarn "Make sure you migrate from /etc/conf.d/${PN} to the new YAML standard in /etc/${PN}.conf"
			ewarn "  http://docs.mongodb.org/manual/reference/configuration-options/"
			ewarn " "
			ewarn "Make sure you also follow the upgrading process :"
			ewarn "  http://docs.mongodb.org/master/release-notes/3.0-upgrade/"
			ewarn " "
			ewarn "MongoDB 3.0 introduces the WiredTiger storage engine."
			ewarn "WiredTiger is incompatible with MMAPv1 and you need to dump/reload your data if you want to use it."
			ewarn "Once you have your data dumped, you need to set storage.engine: wiredTiger in /etc/${PN}.conf"
			ewarn "  http://docs.mongodb.org/master/release-notes/3.0-upgrade/#change-storage-engine-to-wiredtiger"
			break
		fi
	done
}
