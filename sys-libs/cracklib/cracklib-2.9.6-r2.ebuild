# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 libtool multilib-minimal toolchain-funcs usr-ldscript

MY_P=${P/_}
DESCRIPTION="Password Checking Library"
HOMEPAGE="https://github.com/cracklib/cracklib/"
# source tarballs on GitHub lack pre-generated configure script.
#SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="nls python static-libs zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/cracklib-2.9.6-CVE-2016-6318.patch
	"${FILESDIR}"/cracklib-2.9.6-fix-long-word-bufferoverflow.patch
)

do_python() {
	multilib_is_native_abi || return 0
	use python || return 0
	pushd python > /dev/null || die
	distutils-r1_src_${EBUILD_PHASE}
	popd > /dev/null
}

pkg_setup() {
	# workaround #195017
	if has unmerge-orphans ${FEATURES} && has_version "<${CATEGORY}/${PN}-2.8.10" ; then
		eerror "Upgrade path is broken with FEATURES=unmerge-orphans"
		eerror "Please run: FEATURES=-unmerge-orphans emerge cracklib"
		die "Please run: FEATURES=-unmerge-orphans emerge cracklib"
	fi
}

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user
	elibtoolize #269003
	do_python
}

multilib_src_configure() {
	local myeconfargs=(
		# use /usr/lib so that the dictionary is shared between ABIs
		--with-default-dict='/usr/lib/cracklib_dict'
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
	do_python
}

multilib_src_test() {
	# Make sure we load the freshly built library
	LD_LIBRARY_PATH="${BUILD_DIR}/lib/.libs" do_python
}

python_test() {
	${EPYTHON} -m unittest test_cracklib || die "Tests fail with ${EPYTHON}"
}

multilib_src_install() {
	default
	# move shared libs to /
	gen_usr_ldscript -a crack

	do_python
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
	rm -r "${ED%/}"/usr/share/cracklib || die

	insinto /usr/share/dict
	doins dicts/cracklib-small
}

pkg_postinst() {
	if [[ ${ROOT} == "/" ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict "${EPREFIX}"/usr/share/dict/* > /dev/null
		eend $?
	fi
}
