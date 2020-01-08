# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="The MAD id3tag library"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug"

RDEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.1"

PATCHES=(
	"${FILESDIR}"/${PV}/${P}-64bit-long.patch
	"${FILESDIR}"/${PV}/${P}-a_capella.patch
	"${FILESDIR}"/${PV}/${P}-compat.patch
	"${FILESDIR}"/${PV}/${P}-file-write.patch
	"${FILESDIR}"/${PV}/${P}-fix_overflow.patch
	"${FILESDIR}"/${PV}/${P}-tag.patch
	"${FILESDIR}"/${PV}/${P}-unknown-encoding.patch
	"${FILESDIR}"/${PV}/${P}-utf16.patchlibid3tag-0.15.1b-utf16.patch
	"${FILESDIR}"/${P}-fix-signature.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(use_enable debug debugging)
}

multilib_src_install() {
	default

	# This file must be updated with every version update
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}"/id3tag.pc
	sed -i \
		-e "s:prefix=.*:prefix=${EPREFIX}/usr:" \
		-e "s:libdir=\${exec_prefix}/lib:libdir=${EPREFIX}/usr/$(get_libdir):" \
		-e "s:0.15.0b:${PV}:" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/id3tag.pc || die
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
