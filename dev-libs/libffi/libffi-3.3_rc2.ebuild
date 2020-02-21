# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib multilib-minimal toolchain-funcs

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

DESCRIPTION="a portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"
SRC_URI="https://github.com/libffi/libffi/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/7" # SONAME=libffi.so.7
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug pax_kernel static-libs test test-bhaible"

RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND=""
BDEPEND="test? ( dev-util/dejagnu )"

DOCS="ChangeLog* README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-o-tmpfile-eacces.patch #529044
	"${FILESDIR}"/${PN}-3.3_rc0-ppc-macos-go.patch
)

S=${WORKDIR}/${MY_P}

ECONF_SOURCE=${S}

pkg_setup() {
	# Check for orphaned libffi, see https://bugs.gentoo.org/354903 for example
	if [[ ${ROOT} == "/" && ${EPREFIX} == "" ]] && ! has_version ${CATEGORY}/${PN}; then
		local base="${T}"/conftest
		echo 'int main() { }' > "${base}".c
		$(tc-getCC) -o "${base}" "${base}".c -lffi >&/dev/null
		if [ $? -eq 0 ]; then
			eerror "The linker reported linking against -lffi to be working while it shouldn't have."
			eerror "This is wrong and you should find and delete the old copy of libffi before continuing."
			die "The system is in inconsistent state with unknown libffi installed."
		fi
	fi
}

src_prepare() {
	default

	if ! use test-bhaible; then
		# These tests are very heavyweight (hours of runtime)
		rm -v testsuite/libffi.bhaible/bhaible.exp || die
	fi
}

multilib_src_configure() {
	use userland_BSD && export HOST="${CHOST}"
	econf \
		--includedir="${EPREFIX}"/usr/$(get_libdir)/${P}/include \
		--disable-multi-os-directory \
		$(use_enable static-libs static) \
		$(use_enable pax_kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die
	einstalldocs
}
