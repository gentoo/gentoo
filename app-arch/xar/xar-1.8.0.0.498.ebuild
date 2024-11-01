# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs multilib-minimal

APPLE_PV=$(ver_cut 5-)  # 498: macOS 13.3 and up
DESCRIPTION="An easily extensible archive format"
HOMEPAGE="https://github.com/apple-oss-distributions/xar"
SRC_URI="https://github.com/apple-oss-distributions/xar/archive/xar-${APPLE_PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="
	elibc_musl? ( sys-libs/fts-standalone )
	kernel_linux? ( virtual/acl )
	dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-ext2.patch
	"${FILESDIR}"/${PN}-1.8-safe_dirname.patch
	"${FILESDIR}"/${PN}-1.8-arm-ppc.patch
	"${FILESDIR}"/${PN}-1.8-openssl-1.1.patch
	"${FILESDIR}"/${PN}-1.8.0.0.452-linux.patch
	"${FILESDIR}"/${PN}-1.8.0.0.487-non-darwin.patch
	"${FILESDIR}"/${PN}-1.8.0.0.487-variable-sized-object.patch
	"${FILESDIR}"/${PN}-1.8.0.0.498-impl-decls.patch
)

S=${WORKDIR}/${PN}-${PN}-${APPLE_PV}/${PN}

src_prepare() {
	default

	# make lib headers available (without installing first?)
	cd "${S}"/include || die
	mv ../lib/*.h . || die

	# strip RPATH pointing to ED
	cd "${S}"/src || die
	sed -i -e 's/@RPATH@//' Makefile.inc.in || die

	# avoid GNU make (bug?) behaviour of removing xar.o as intermediate
	# file, this doesn't happen outside portage, but it does from the
	# ebuild env, causing the install phase to re-compile xar.o and link
	# the executable
	echo ".PRECIOUS: @objroot@src/%.o" >> Makefile.inc.in || die

	# drop Darwin specific reliance on CommonCrypto Framework, for it
	# depends on what version of Darwin we're on, and it is much simpler
	# to just use openessl instead, which we maintain and control
	cd "${S}" || die
	sed -i -e 's/__APPLE__/__NO_APPLE__/' \
		include/archive.h \
		lib/hash.c \
		|| die

	# fix branding somewhat
	sed -i -e "/XAR_VERSION/s|%s|%s (Gentoo ${PVR})|" src/xar.c || die

	eautoreconf
}

multilib_src_configure() {
	append-libs $($(tc-getPKG_CONFIG) --libs openssl)
	use elibc_musl && append-libs $($(tc-getPKG_CONFIG) --libs fts-standalone)
	append-cflags -Wno-unused-result  # allow to see real problems
	ECONF_SOURCE=${S} \
	econf --disable-static
	# botched check, fix it up
	if use kernel_SunOS ; then
		sed -i -e '/HAVE_SYS_ACL_H/s:^\(.*\)$:/* \1 */:' include/config.h || die
	fi
	# allow xar/xar.h to be found
	( cd include && ln -s . xar )
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
