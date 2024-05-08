# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"
inherit python-single-r1 waf-utils multilib-minimal

DESCRIPTION="LDAP-like embedded database"
HOMEPAGE="https://ldb.samba.org"
SRC_URI="https://samba.org/ftp/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc ldap +lmdb python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( lmdb )"

RESTRICT="!test? ( test )"

TALLOC_VERSION="2.4.2"
TDB_VERSION="1.4.10"
TEVENT_VERSION="0.16.1"

RDEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	>=sys-libs/talloc-${TALLOC_VERSION}[${MULTILIB_USEDEP}]
	>=sys-libs/tdb-${TDB_VERSION}[${MULTILIB_USEDEP}]
	>=sys-libs/tevent-${TEVENT_VERSION}[${MULTILIB_USEDEP}]
	ldap? ( net-nds/openldap:= )
	lmdb? ( >=dev-db/lmdb-0.9.16:=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		sys-libs/talloc[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tdb[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tevent[python,${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	virtual/libcrypt
	test? ( >=dev-util/cmocka-1.1.3[${MULTILIB_USEDEP}] )
"
BDEPEND="${PYTHON_DEPS}
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

WAF_BINARY="${S}/buildtools/bin/waf"

MULTILIB_WRAPPED_HEADERS=( /usr/include/pyldb.h )

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.0-optional_packages.patch
	"${FILESDIR}"/${PN}-1.1.31-fix_PKGCONFIGDIR-when-python-disabled.patch
	"${FILESDIR}"/${PN}-2.4.2-skip-32bit-time_t-tests.patch
	"${FILESDIR}"/${PN}-2.5.2-skip-waf-tevent-check.patch
)

pkg_setup() {
	# Package fails to build with distcc
	export DISTCC_DISABLE=1
	export PYTHONHASHSEED=1

	# waf requires a python interpreter
	python-single-r1_pkg_setup
}

check_samba_dep_versions() {
	actual_talloc_version=$(sed -En '/^VERSION =/{s/[^0-9.]//gp}' lib/talloc/wscript || die)
	if [[ ${actual_talloc_version} != ${TALLOC_VERSION} ]] ; then
		eerror "Source talloc version: ${TALLOC_VERSION}"
		eerror "Ebuild talloc version: ${actual_talloc_version}"
		die "Ebuild needs to fix TALLOC_VERSION!"
	fi

	actual_tdb_version=$(sed -En '/^VERSION =/{s/[^0-9.]//gp}' lib/tdb/wscript || die)
	if [[ ${actual_tdb_version} != ${TDB_VERSION} ]] ; then
		eerror "Source tdb version: ${TDB_VERSION}"
		eerror "Ebuild tdb version: ${actual_tdb_version}"
		die "Ebuild needs to fix TDB_VERSION!"
	fi

	actual_tevent_version=$(sed -En '/^VERSION =/{s/[^0-9.]//gp}' lib/tevent/wscript || die)
	if [[ ${actual_tevent_version} != ${TEVENT_VERSION} ]] ; then
		eerror "Source tevent version: ${TEVENT_VERSION}"
		eerror "Ebuild tevent version: ${actual_tevent_version}"
		die "Ebuild needs to fix TEVENT_VERSION!"
	fi
}

src_prepare() {
	default

	check_samba_dep_versions

	if use test && ! use python ; then
		# We want to be able to run tests w/o Python as it makes
		# automated testing much easier (as USE=python isn't default-enabled).
		truncate -s0 tests/python/{repack,index,api,crash}.py || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	# When specifying libs for samba build you must append NONE to the end to
	# stop it automatically including things
	local bundled_libs="NONE"

	# We "use" bundled cmocka when we're not running tests as we're
	# not using it anyway. Means we avoid making users install it for
	# no reason. bug #802531
	if ! use test; then
		bundled_libs="cmocka,${bundled_libs}"
	fi

	local myconf=(
		$(usex ldap '' --disable-ldap)
		$(usex lmdb '' --without-ldb-lmdb)
		--disable-rpath
		--disable-rpath-install
		--with-modulesdir="${EPREFIX}"/usr/$(get_libdir)/samba
		--bundled-libraries="${bundled_libs}"
		--builtin-libraries=NONE
	)

	if ! use python || ! multilib_is_native_abi; then
		myconf+=( --disable-python )
	fi

	waf-utils_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	waf-utils_src_compile
	multilib_is_native_abi && use doc && doxygen Doxyfile
}

multilib_src_test() {
	if multilib_is_native_abi; then
		WAF_MAKE=1 \
		PATH=buildtools/bin:../../../buildtools/bin:${PATH}:"${BUILD_DIR}"/bin/shared/private/ \
		LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${BUILD_DIR}"/bin/shared/private/:"${BUILD_DIR}"/bin/shared \
		waf test || die
	fi
}

multilib_src_install() {
	waf-utils_src_install

	if multilib_is_native_abi && use doc; then
		doman  apidocs/man/man3/*.3
		docinto html
		dodoc -r apidocs/html/.
	fi

	# bug #726454
	use python && python_optimize
}

pkg_postinst() {
	if has_version sys-auth/sssd; then
		ewarn "You have sssd installed. It is known to break after ldb upgrades,"
		ewarn "so please try to rebuild it before reporting bugs."
		ewarn "See https://bugs.gentoo.org/404281"
	fi
}
