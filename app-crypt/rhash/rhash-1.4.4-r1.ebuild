# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="Console utility and library for computing and verifying file hash sums"
HOMEPAGE="https://rhash.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="0BSD"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
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
	"${FILESDIR}"/${P}-prefix.patch
)

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] ; then
		# we lack posix_memalign
		sed -i -e '/if _POSIX_VERSION/s/if .*$/if 0/' \
			librhash/util.h || die
	fi

	# upstream fix for BSD and others, but was only applied for BSD
	# we need support for Solaris, where we use a GNU toolchain, so use
	# the original hack, hopefully next release has this fixed
	# https://github.com/rhash/RHash/issues/238
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/^elif linux; then/else/' configure || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

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

multilib_src_compile() {
	emake all \
		$(multilib_is_native_abi && use nls && echo compile-gmo)
}

multilib_src_install() {
	# -j1 needed due to race condition.
	emake DESTDIR="${D}" -j1 \
		install{,-lib-headers,-pkg-config} \
		$(multilib_is_native_abi && use nls && echo install-gmo) \
		install-lib-so-link
}

multilib_src_test() {
	emake test
}
