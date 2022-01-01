# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://boostorg.github.io/build/"
SRC_URI="https://boostorg.jfrog.io/artifactory/main/release/${PV}/source/boost_${MY_PV}.tar.bz2"
S="${WORKDIR}/boost_${MY_PV}/tools/build/src"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.71.0-disable_python_rpath.patch
	"${FILESDIR}"/${PN}-1.71.0-darwin-gentoo-toolchain.patch
	"${FILESDIR}"/${PN}-1.73.0-add-none-feature-options.patch
	"${FILESDIR}"/${PN}-1.76.0-respect-user-flags.patch
	"${FILESDIR}"/${PN}-1.74.0-no-implicit-march-flags.patch
	"${FILESDIR}"/${PN}-1.76.0-python-numpy.patch
)

src_unpack() {
	tar xojf "${DISTDIR}/${A}" boost_${MY_PV}/tools/build || die "unpacking tar failed"
}

src_prepare() {
	default

	pushd .. >/dev/null || die
	eapply "${FILESDIR}"/${PN}-1.71.0-fix-test.patch
	popd >/dev/null || die
}

src_configure() {
	# need to enable LFS explicitly for 64-bit offsets on 32-bit hosts (#761100)
	append-lfs-flags
}

src_compile() {
	cd engine || die
	${CONFIG_SHELL:-${BASH}} ./build.sh cxx --cxx="$(tc-getCXX)" --cxxflags="${CXXFLAGS}" -d+2 --without-python || die "building bjam failed"
}

src_test() {
	# Forget tests, bjam is a lost cause
	:
}

src_install() {
	dobin engine/{bjam,b2}

	insinto /usr/share/boost-build/src
	doins -r "${FILESDIR}/site-config.jam" \
		../boost-build.jam bootstrap.jam build-system.jam ../example/user-config.jam *.py \
		build kernel options tools util

	find "${ED}"/usr/share/boost-build/src -iname '*.py' -delete || die

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
