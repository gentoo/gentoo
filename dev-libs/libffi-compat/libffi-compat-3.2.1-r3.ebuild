# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils libtool multilib multilib-minimal toolchain-funcs

DESCRIPTION="a portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"
SRC_URI="ftp://sourceware.org/pub/libffi/libffi-${PV}.tar.gz"

LICENSE="MIT"
SLOT="6" # libffi.so.6
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug pax_kernel test"

RESTRICT="!test? ( test )"

RDEPEND="!dev-libs/libffi:0/0" # conflicts on libffi.so.6
DEPEND="test? ( dev-util/dejagnu )"

DOCS="ChangeLog* README"

PATCHES=(
	"${FILESDIR}"/libffi-3.2.1-o-tmpfile-eacces.patch #529044
	"${FILESDIR}"/libffi-3.2.1-complex_alpha.patch
	"${FILESDIR}"/libffi-3.1-darwin-x32.patch
	"${FILESDIR}"/libffi-3.2.1-complex-ia64.patch
	"${FILESDIR}"/libffi-3.2.1-include-path.patch
	"${FILESDIR}"/libffi-3.2.1-include-path-autogen.patch
	"${FILESDIR}"/libffi-3.2.1-ia64-small-struct.patch #634190
	"${FILESDIR}"/libffi-3.2.1-musl-emutramp.patch #694916
)

S=${WORKDIR}/libffi-${PV}
ECONF_SOURCE=${S}

src_prepare() {
	default

	sed -i -e 's:@toolexeclibdir@:$(libdir):g' Makefile.in || die #462814
	elibtoolize
}

multilib_src_configure() {
	use userland_BSD && export HOST="${CHOST}"
	econf \
		--disable-static \
		$(use_enable pax_kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_install() {
	dolib.so .libs/libffi.so.${SLOT}*
}
