# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 multilib-minimal multiprocessing

DESCRIPTION="High level interface to Linux seccomp filter"
HOMEPAGE="https://github.com/seccomp/libseccomp"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/seccomp/libseccomp.git"
	PRERELEASE="2.6.0"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libseccomp.asc
	inherit verify-sig

	SRC_URI="
		https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz.asc )
	"
	KEYWORDS="-* amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-libseccomp )"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="python static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
# We need newer kernel headers; we don't keep strict control of the exact
# version here, just be safe and pull in the latest stable ones. bug #551248
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.15
"
BDEPEND+="
	${DEPEND}
	dev-util/gperf
	python? (
		${DISTUTILS_DEPS}
		dev-python/cython[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/libseccomp-2.6.0-python-shared.patch
	"${FILESDIR}"/libseccomp-2.5.3-skip-valgrind.patch
	"${FILESDIR}"/${P}-drop-bogus-test.patch
	"${FILESDIR}"/${P}-aliasing.patch
	"${FILESDIR}"/${P}-bounds.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	fi

	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	default
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]] ; then
		sed -i -e "s/0.0.0/${PRERELEASE}/" configure.ac || die

		eautoreconf
	fi

	# Silence noise when running Python tests
	sed -i -e 's:$(pwd)/../src/python/build/lib\.\*:$(pwd):' tests/regression || die
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-python
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use python ; then
		# setup.py expects libseccomp.so to live in "../.libs"
		# Copy the python files to the right place for this.
		rm -r "${BUILD_DIR}"/src/python || die
		cp -r "${S}"/src/python "${BUILD_DIR}"/src/python || die
		local -x CPPFLAGS="-I\"${BUILD_DIR}/include\" -I\"${S}/include\" ${CPPFLAGS}"

		# setup.py reads VERSION_RELEASE from the environment
		local -x VERSION_RELEASE=${PRERELEASE-${PV}}

		pushd "${BUILD_DIR}/src/python" >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

multilib_src_test() {
	local -x LIBSECCOMP_TSTCFG_JOBS="$(makeopts_jobs)"
	emake -Onone check

	if multilib_is_native_abi && use python ; then
		distutils-r1_src_test
	fi
}

python_test() {
	local -x LIBSECCOMP_TSTCFG_MODE_LIST="python"

	emake -Onone check
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python ; then
		distutils-r1_src_install
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "${PN}.la" -delete || die

	einstalldocs
}
