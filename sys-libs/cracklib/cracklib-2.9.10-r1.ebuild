# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: ideally bump with sys-apps/cracklib-words

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 libtool multilib-minimal usr-ldscript

MY_P=${P/_}
DESCRIPTION="Password Checking Library"
HOMEPAGE="https://github.com/cracklib/cracklib/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls python static-libs zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	nls? ( virtual/libintl )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	python? ( ${DISTUTILS_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.10-python-inc.patch
)

distutils_enable_tests unittest

pkg_setup() {
	# Workaround bug #195017
	if has unmerge-orphans ${FEATURES} && has_version "<${CATEGORY}/${PN}-2.8.10" ; then
		eerror "Upgrade path is broken with FEATURES=unmerge-orphans"
		eerror "Please run: FEATURES=-unmerge-orphans emerge cracklib"
		die "Please run: FEATURES=-unmerge-orphans emerge cracklib"
	fi
}

src_prepare() {
	default

	# bug #269003
	elibtoolize

	if use python ; then
		distutils-r1_src_prepare
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		# use /usr/lib so that the dictionary is shared between ABIs
		--with-default-dict="/usr/lib/cracklib_dict"
		--without-python
		$(use_enable nls)
		$(use_enable static-libs static)
	)

	export ac_cv_header_zlib_h=$(usex zlib)
	export ac_cv_search_gzopen=$(usex zlib -lz no)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python ; then
		local -x CFLAGS="${CFLAGS} -DLOCALEDIR='\"${EPREFIX}/usr/share/locale\"' -DDEFAULT_CRACKLIB_DICT=\'${EPREFIX}/usr/lib/cracklib_dict\'"
		cd python || die
		distutils-r1_src_compile
	fi
}

multilib_src_test() {
	default

	if multilib_is_native_abi && use python ; then
		distutils-r1_src_test
	fi
}

python_test() {
	cd "${S}"/python || die

	# Make sure we load the freshly built library
	local -x LD_LIBRARY_PATH="${BUILD_DIR/-${EPYTHON/./_}}/lib/.libs:${BUILD_DIR}/lib:${LD_LIBRARY_PATH}"

	eunittest
}

multilib_src_install() {
	default

	# Move shared libs to /
	gen_usr_ldscript -a crack

	if multilib_is_native_abi && use python ; then
		cd python || die
		distutils-r1_src_install
	fi
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name "*.la" -delete || die
	rm -r "${ED}"/usr/share/cracklib || die

	insinto /usr/share/dict
	doins dicts/cracklib-small
}

pkg_postinst() {
	if [[ -z ${ROOT} ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict "${EPREFIX}"/usr/share/dict/* > /dev/null
		eend $?
	fi
}
