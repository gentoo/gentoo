# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit python-single-r1 waf-utils multilib-minimal

DESCRIPTION="LDAP-like embedded database"
HOMEPAGE="https://ldb.samba.org"
SRC_URI="https://samba.org/ftp/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc ldap +lmdb python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( lmdb python )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	>=dev-util/cmocka-1.1.3[${MULTILIB_USEDEP}]
	>=sys-libs/talloc-2.3.3[${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.4.4[${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.11.0[${MULTILIB_USEDEP}]
	ldap? ( net-nds/openldap:= )
	lmdb? ( >=dev-db/lmdb-0.9.16:=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		sys-libs/talloc[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tdb[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tevent[python,${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	virtual/libcrypt
"
BDEPEND="${PYTHON_DEPS}
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

WAF_BINARY="${S}/buildtools/bin/waf"

MULTILIB_WRAPPED_HEADERS=( /usr/include/pyldb.h )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.2-optional_packages.patch
	"${FILESDIR}"/${PN}-1.1.31-fix_PKGCONFIGDIR-when-python-disabled.patch
	"${FILESDIR}"/${PN}-2.4.2-skip-32bit-time_t-tests.patch
	"${FILESDIR}"/${PN}-2.5.2-skip-waf-tevent-check.patch
)

pkg_setup() {
	# Package fails to build with distcc
	export DISTCC_DISABLE=1

	# waf requires a python interpreter
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		$(usex ldap '' --disable-ldap)
		$(usex lmdb '' --without-ldb-lmdb)
		--disable-rpath
		--disable-rpath-install --bundled-libraries=NONE
		--with-modulesdir="${EPREFIX}"/usr/$(get_libdir)/samba
		--builtin-libraries=NONE
	)
	if ! multilib_is_native_abi; then
		myconf+=( --disable-python )
	else
		use python || myconf+=( --disable-python )
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
		PATH=buildtools/bin:../../../buildtools/bin:$PATH:"${BUILD_DIR}"/bin/shared/private/ \
		LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${BUILD_DIR}"/bin/shared/private/:"${BUILD_DIR}"/bin/shared \
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

	use python && python_optimize #726454
}

pkg_postinst() {
	if has_version sys-auth/sssd; then
		ewarn "You have sssd installed. It is known to break after ldb upgrades,"
		ewarn "so please try to rebuild it before reporting bugs."
		ewarn "See https://bugs.gentoo.org/404281"
	fi
}
