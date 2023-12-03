# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 multilib-minimal

DESCRIPTION="high level interface to Linux seccomp filter"
HOMEPAGE="https://github.com/seccomp/libseccomp"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/seccomp/libseccomp.git"
	PRERELEASE="2.6.0"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz
		experimental-loong? ( https://dev.gentoo.org/~xen0n/distfiles/${PN}-2.5.4-loongarch64-20220425.patch.xz )"
	KEYWORDS="-* ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="experimental-loong python static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# We need newer kernel headers; we don't keep strict control of the exact
# version here, just be safe and pull in the latest stable ones. bug #551248
DEPEND=">=sys-kernel/linux-headers-5.15
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}
	dev-util/gperf
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/libseccomp-python-shared.patch
	"${FILESDIR}"/libseccomp-2.5.3-skip-valgrind.patch
)

src_prepare() {
	if use experimental-loong; then
		PATCHES+=( "${WORKDIR}/${PN}-2.5.4-loongarch64-20220425.patch" )
	fi

	default

	if use experimental-loong; then
		# touch generated files to avoid activating maintainer mode
		# remove when loong-fix-build.patch is no longer necessary
		touch ./aclocal.m4 ./configure ./configure.h.in || die
		find . -name Makefile.in -exec touch {} + || die
	fi

	if [[ ${PV} == *9999 ]] ; then
		sed -i -e "s/0.0.0/${PRERELEASE}/" configure.ac || die

		eautoreconf
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-python
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

do_python() {
	# setup.py reads VERSION_RELEASE from the environment
	local -x VERSION_RELEASE=${PRERELEASE-${PV}}

	pushd "${BUILD_DIR}/src/python" >/dev/null || die
	"$@"
	popd >/dev/null || die
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use python ; then
		# setup.py expects libseccomp.so to live in "../.libs"
		# Copy the python files to the right place for this.
		rm -r "${BUILD_DIR}"/src/python || die
		cp -r "${S}"/src/python "${BUILD_DIR}"/src/python || die
		local -x CPPFLAGS="-I\"${BUILD_DIR}/include\" -I\"${S}/include\" ${CPPFLAGS}"

		do_python distutils-r1_src_compile
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python ; then
		do_python distutils-r1_src_install
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "${PN}.la" -delete || die

	einstalldocs
}
