# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# eutils for einstalldocs
inherit epatch epunt-cxx eutils libtool ltprune multilib multilib-minimal

DESCRIPTION="The MAD id3tag library"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/gperf"

src_prepare() {
	epunt_cxx #74489
	epatch "${FILESDIR}/${PV}"/*.patch
	# gperf 3.1 and newer generate code with a size_t length parameter,
	# older versions are incompatible and take an unsigned int.
	has_version '>=dev-util/gperf-3.1' && epatch "${FILESDIR}/${P}-fix-signature.patch"

	elibtoolize #sane .so versionning on fbsd and .so -> .so.version symlink
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
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
	prune_libtool_files --all
	einstalldocs
}
