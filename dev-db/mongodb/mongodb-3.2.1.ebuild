# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
SCONS_MIN_VERSION="2.3.0"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit eutils flag-o-matic multilib pax-utils scons-utils systemd toolchain-funcs user versionator check-reqs

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="https://fastdl.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kerberos libressl mms-agent ssl test +tools"

RDEPEND=">=app-arch/snappy-1.1.2
	|| ( =dev-cpp/yaml-cpp-0.5.1 >dev-cpp/yaml-cpp-0.5.2 )
	>=dev-libs/boost-1.57[threads(+)]
	>=dev-libs/libpcre-8.37[cxx]
	dev-libs/snowball-stemmer
	net-libs/libpcap
	>=sys-libs/zlib-1.2.8
	mms-agent? ( app-admin/mms-agent )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1g:0= )
		libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.8.2:*
	sys-libs/ncurses
	sys-libs/readline
	debug? ( dev-util/valgrind )
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )
	test? (
		dev-python/pymongo
		dev-python/pyyaml
	)"
PDEPEND="tools? ( >=app-admin/mongo-tools-${PV} )"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	if [[ ${REPLACING_VERSIONS} < 3.0 ]]; then
		ewarn "To upgrade an existing MongoDB deployment to 3.2, you must be"
		ewarn "running a 3.0-series release. Please update to the latest 3.0"
		ewarn "release before continuing if wish to keep your data."
	fi
}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	# Maintainer notes
	#
	# --use-system-tcmalloc is strongly NOT recommended:
	# https://www.mongodb.org/about/contributors/tutorial/build-mongodb-from-source/

	scons_opts=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"

		--disable-warnings-as-errors
		--use-system-boost
		--use-system-pcre
		--use-system-snappy
		--use-system-stemmer
		--use-system-yaml
		--use-system-zlib
	)

	# wiredtiger not supported on 32bit platforms #572166
	use x86 && scons_opts+=( --wiredtiger=off )

	if use debug; then
		scons_opts+=( --dbg=on )
	fi

	if use prefix; then
		scons_opts+=(
			--cpppath="${EPREFIX}/usr/include"
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

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.2.0-fix-scons.patch"
	epatch_user
}

src_compile() {
	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi
	escons "${scons_opts[@]}" core tools
}

src_install() {
	escons "${scons_opts[@]}" --nostrip install --prefix="${ED}"/usr

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r2" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd-r2" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd-r2" ${PN/db/s}

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
	# this one test fails
	rm jstests/core/repl_write_threads_start_param.js

	./buildscripts/resmoke.py --dbpathPrefix=test --suites core || die "Tests failed"
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 3.0 ]]; then
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
	fi

	ewarn "Make sure to read the release notes and follow the upgrade process:"
	ewarn "  https://docs.mongodb.org/manual/release-notes/3.2/"
	ewarn "  https://docs.mongodb.org/master/release-notes/3.2-upgrade/"
	ewarn
	ewarn " Starting in 3.2, MongoDB uses the WiredTiger as the default storage engine."
}
