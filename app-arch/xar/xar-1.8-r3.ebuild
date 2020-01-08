# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic multilib-minimal multilib

APPLE_PV=417.1
DESCRIPTION="An easily extensible archive format"
HOMEPAGE="https://opensource.apple.com/source/xar/"
SRC_URI="https://opensource.apple.com/tarballs/xar/xar-${APPLE_PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libressl kernel_Darwin"

DEPEND="
	!kernel_Darwin? (
		!kernel_SunOS? ( virtual/acl )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-ext2.patch
	"${FILESDIR}"/${PN}-1.8-safe_dirname.patch
	"${FILESDIR}"/${PN}-1.8-arm-ppc.patch
	"${FILESDIR}"/${PN}-1.8-openssl-1.1.patch
)

S=${WORKDIR}/${PN}-${APPLE_PV}/${PN}

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
}

multilib_src_configure() {
	use kernel_Darwin || append-libs $(pkg-config --libs openssl)
	ECONF_SOURCE=${S} \
	econf \
		--disable-static
	# botched check, fix it up
	if use kernel_SunOS ; then
		sed -i -e '/HAVE_SYS_ACL_H/s:^\(.*\)$:/* \1 */:' include/config.h || die
	fi
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
