# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

SCONS_MIN_VERSION="2.5.0"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit check-reqs eutils flag-o-matic multilib multiprocessing pax-utils python-single-r1 scons-utils systemd toolchain-funcs user versionator

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://fastdl.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug kerberos libressl mms-agent ssl test +tools"

RDEPEND=">=app-arch/snappy-1.1.3
	>=dev-cpp/yaml-cpp-0.5.3
	>=dev-libs/boost-1.60:=[threads(+)]
	>=dev-libs/libpcre-8.41[cxx]
	dev-libs/snowball-stemmer
	net-libs/libpcap
	>=sys-libs/zlib-1.2.11:=
	mms-agent? ( app-admin/mms-agent )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1g:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-python/cheetah[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	<dev-util/scons-3
	sys-libs/ncurses
	sys-libs/readline
	debug? ( dev-util/valgrind )
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )
	test? (
		dev-python/pymongo[${PYTHON_USEDEP}]
	)"
PDEPEND="tools? ( >=app-admin/mongo-tools-${PV} )"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.7-no-boost-check.patch"
	"${FILESDIR}/${PN}-3.6.1-fix-scons.patch"
	"${FILESDIR}/${PN}-4.0.0-no-compass.patch"
)

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	if [[ -n ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 3.6 ]]; then
		ewarn "To upgrade from a version earlier than the 3.6-series, you must"
		ewarn "successively upgrade major releases until you have upgraded"
		ewarn "to 3.6-series. Then upgrade to 4.0 series."
	elif [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn "Be sure to set featureCompatibilityVersion to 3.6 before upgrading."
	fi
}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# remove bundled libs
	rm -r src/third_party/{boost-*,pcre-*,scons-*,snappy-*,yaml-cpp-*,zlib-*} || die

	# remove compass
	rm -r src/mongo/installer/compass || die
}

src_configure() {
	# https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
	# --use-system-icu fails tests
	# --use-system-tcmalloc is strongly NOT recommended:
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

	use debug && scons_opts+=( --dbg=on )
	use kerberos && scons_opts+=( --use-sasl-client )
	use ssl && scons_opts+=( --ssl )

	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi

	default
}

src_compile() {
	escons "${scons_opts[@]}" core tools
}

# FEATURES="test -usersandbox" emerge dev-db/mongodb
src_test() {
	"${EPYTHON}" ./buildscripts/resmoke.py --dbpathPrefix=test --suites core --jobs=$(makeopts_jobs) || die "Tests failed"
}

src_install() {
	escons "${scons_opts[@]}" --nostrip install --prefix="${ED}"/usr

	local x
	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
		fperms 0750 "${x}"
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

pkg_postinst() {
	ewarn "Make sure to read the release notes and follow the upgrade process:"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(get_version_component_range 1-2)/"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(get_version_component_range 1-2)/#upgrade-procedures"
}
