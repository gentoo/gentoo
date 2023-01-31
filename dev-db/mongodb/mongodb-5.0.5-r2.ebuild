# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

SCONS_MIN_VERSION="3.3.1"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit check-reqs flag-o-matic multiprocessing pax-utils python-any-r1 scons-utils systemd toolchain-funcs

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://fastdl.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="amd64 ~arm64 -riscv"
CPU_FLAGS="cpu_flags_x86_avx"
IUSE="debug kerberos lto mongosh ssl +tools ${CPU_FLAGS}"

# https://github.com/mongodb/mongo/wiki/Test-The-Mongodb-Server
# resmoke needs python packages not yet present in Gentoo
RESTRICT="test"

RDEPEND="acct-group/mongodb
	acct-user/mongodb
	>=app-arch/snappy-1.1.3:=
	>=dev-cpp/yaml-cpp-0.6.2:=
	dev-libs/boost:=[nls]
	>=dev-libs/libpcre-8.42[cxx]
	app-arch/zstd:=
	dev-libs/snowball-stemmer:=
	net-libs/libpcap
	>=sys-libs/zlib-1.2.11:=
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )
	ssl? (
		>=dev-libs/openssl-1.0.1g:0=
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	debug? ( dev-util/valgrind )"
BDEPEND="
	$(python_gen_any_dep '
		>=dev-util/scons-3.1.1[${PYTHON_USEDEP}]
		dev-python/cheetah3[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
PDEPEND="
	mongosh? ( app-admin/mongosh-bin )
	tools? ( >=app-admin/mongo-tools-100 )
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.1-boost.patch"
	"${FILESDIR}/${PN}-4.4.1-gcc11.patch"
	"${FILESDIR}/${PN}-5.0.2-fix-scons.patch"
	"${FILESDIR}/${PN}-5.0.2-no-compass.patch"
	"${FILESDIR}/${PN}-5.0.2-skip-no-exceptions.patch"
	"${FILESDIR}/${PN}-5.0.2-skip-reqs-check.patch"
	"${FILESDIR}/${PN}-5.0.2-boost-1.79.patch"
	"${FILESDIR}/${PN}-5.0.5-no-force-lld.patch"
	"${FILESDIR}/${PN}-4.4.10-boost-1.81.patch"
	"${FILESDIR}/${PN}-5.0.5-boost-1.81-extra.patch"
	"${FILESDIR}/${PN}-4.4.8-gcc-13.patch"
)

S="${WORKDIR}/${MY_P}"

python_check_deps() {
	python_has_version ">=dev-util/scons-3.1.1[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/cheetah3[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/psutil[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	# Bug 809692
	if use amd64 && ! use cpu_flags_x86_avx; then
		eerror "MongoDB 5.0 requires use of the AVX instruction set"
		eerror "https://docs.mongodb.com/v5.0/administration/production-notes/"
		die "MongoDB requires AVX"
	fi

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ver_test "$REPLACING_VERSIONS" -lt 4.4; then
			ewarn "To upgrade from a version earlier than the 4.4-series, you must"
			ewarn "successively upgrade major releases until you have upgraded"
			ewarn "to 4.4-series. Then upgrade to 5.0 series."
		else
			ewarn "Be sure to set featureCompatibilityVersion to 4.4 before upgrading."
		fi
	fi
}

src_prepare() {
	default

	# remove bundled libs
	rm -r src/third_party/{boost,pcre-*,snappy-*,yaml-cpp,zlib-*} || die

	# remove compass
	rm -r src/mongo/installer/compass || die
}

src_configure() {
	# https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
	# --use-system-icu fails tests
	# --use-system-tcmalloc is strongly NOT recommended:
	scons_opts=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"

		--disable-warnings-as-errors
		--jobs="$(makeopts_jobs)"
		--use-system-boost
		--use-system-pcre
		--use-system-snappy
		--use-system-stemmer
		--use-system-yaml
		--use-system-zlib
		--use-system-zstd
	)

	use arm64 && scons_opts+=( --use-hardware-crc32=off ) # Bug 701300
	use debug && scons_opts+=( --dbg=on )
	use kerberos && scons_opts+=( --use-sasl-client )
	use lto && scons_opts+=( --lto=on )

	scons_opts+=( --ssl=$(usex ssl on off) )

	# Needed to avoid forcing FORTIFY_SOURCE
	# Gentoo's toolchain applies these anyway
	scons_opts+=( --runtime-hardening=off )

	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi

	default
}

src_compile() {
	PREFIX="${EPREFIX}/usr" ./buildscripts/scons.py "${scons_opts[@]}" install-core || die
}

src_install() {
	dobin build/install/bin/{mongo,mongod,mongos}

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r3" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r3" ${PN}
	newinitd "${FILESDIR}/mongos.initd-r3" mongos
	newconfd "${FILESDIR}/mongos.confd-r3" mongos

	insinto /etc
	newins "${FILESDIR}/${PN}.conf-r3" ${PN}.conf
	newins "${FILESDIR}/mongos.conf-r2" mongos.conf

	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongo,mongod,mongos}

	local x
	for x in /var/{lib,log}/${PN}; do
		diropts -m0750 -o mongodb -g mongodb
		keepdir "${x}"
	done
}

pkg_postinst() {
	ewarn "Make sure to read the release notes and follow the upgrade process:"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/#upgrade-procedures"
}
