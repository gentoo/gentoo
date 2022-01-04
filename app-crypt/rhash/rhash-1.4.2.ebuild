# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Console utility and library for computing and verifying file hash sums"
HOMEPAGE="http://rhash.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nls ssl static-libs"

RDEPEND="
	ssl? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}]
)"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/RHash-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] ; then
		# we lack posix_memalign
		sed -i -e '/if _POSIX_VERSION/s/if .*$/if 0/' \
			librhash/util.h || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	set -- \
		./configure \
		--target="${CHOST}" \
		--cc="$(tc-getCC)" \
		--ar="$(tc-getAR)" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--sysconfdir="${EPREFIX}"/etc \
		--disable-openssl-runtime \
		--disable-static \
		--enable-lib-shared \
		$(use_enable debug) \
		$(use_enable nls gettext) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs lib-static)

	echo "${@}"
	"${@}" || die "configure failed"
}

# We would add compile-gmo to the build targets but install-gmo always
# recompiles unconditionally. :(
# (note from sam: this might be fixed in >1.4.2?
#  https://github.com/rhash/RHash/commit/9e4eeb1268149b24b7fbe0fc0fe91e3a266e6261)

multilib_src_install() {
	# -j1 needed due to race condition.
	emake DESTDIR="${D}" -j1 \
		install{,-lib-headers,-pkg-config} \
		$(use nls && echo install-gmo) \
		$(use kernel_Winnt || echo install-lib-so-link)
}

multilib_src_test() {
	emake test
}
