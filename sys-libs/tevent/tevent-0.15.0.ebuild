# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils multilib-minimal python-single-r1

DESCRIPTION="Samba tevent library"
HOMEPAGE="https://tevent.samba.org/"
SRC_URI="https://samba.org/ftp/tevent/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~x86-linux"
IUSE="python test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

TALLOC_VERSION="2.4.1"

RDEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	>=sys-libs/talloc-${TALLOC_VERSION}[${MULTILIB_USEDEP}]
	python? (
		${PYTHON_DEPS}
		>=sys-libs/talloc-${TALLOC_VERSION}[python,${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	elibc_glibc? (
		net-libs/libtirpc[${MULTILIB_USEDEP}]
		net-libs/rpcsvc-proto
	)
	test? ( >=dev-util/cmocka-1.1.3 )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/cmocka-config_h.patch
)

WAF_BINARY="${S}/buildtools/bin/waf"

check_samba_dep_versions() {
	actual_talloc_version=$(sed -En '/^VERSION =/{s/[^0-9.]//gp}' lib/talloc/wscript || die)
	if [[ ${actual_talloc_version} != ${TALLOC_VERSION} ]] ; then
		eerror "Source talloc version: ${TALLOC_VERSION}"
		eerror "Ebuild talloc version: ${actual_talloc_version}"
		die "Ebuild needs to fix TALLOC_VERSION!"
	fi
}

src_prepare() {
	default

	check_samba_dep_versions

	if use test ; then
		# TODO: Fix python tests to run w/ USE=python.
		# (depsite the name. bindings.py is just for Python tests.)
		truncate -s0 bindings.py || die
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
	if ! use test ; then
		bundled_libs="cmocka,${bundled_libs}"
	fi

	waf-utils_src_configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--disable-dependency-tracking \
		--disable-warnings-as-errors \
		--bundled-libraries="${bundled_libs}" \
		--builtin-libraries=NONE \
		$(multilib_native_usex python '' '--disable-python')
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	multilib_is_native_abi && use python && python_domodule tevent.py
}

multilib_src_install_all() {
	insinto /usr/include
	doins tevent_internal.h
}
