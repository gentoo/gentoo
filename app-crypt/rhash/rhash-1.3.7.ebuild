# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Console utility and library for computing and verifying file hash sums"
HOMEPAGE="http://rhash.anz.ru/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="debug nls libressl ssl static-libs"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
)"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/RHash-${PV}"

src_prepare() {
	default
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
