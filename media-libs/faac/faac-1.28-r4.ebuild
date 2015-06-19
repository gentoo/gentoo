# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faac/faac-1.28-r4.ebuild,v 1.11 2014/01/26 12:13:59 ago Exp $

EAPI=5
inherit autotools eutils multilib-minimal

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="http://www.audiocoding.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1 MPEG-4"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="media-libs/libmp4v2:0=
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r1
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-external-libmp4v2.patch \
		"${FILESDIR}"/${P}-altivec.patch \
		"${FILESDIR}"/${P}-libmp4v2_r479_compat.patch \
		"${FILESDIR}"/${P}-inttypes.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #466984

	eautoreconf
	epunt_cxx
}

multilib_src_configure() {
	local myconf
	# only used for the fronted we need only for the default ABI.
	[ "${ABI}" != "${DEFAULT_ABI}" ] && myconf+=" --without-mp4v2"

	ECONF_SOURCE="${S}"	econf \
		$(use_enable static-libs static) \
		${myconf}

	# do not build the frontend for non default abis
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		sed -i -e 's/frontend//' Makefile || die
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}

multilib_src_install_all() {
	einstalldocs
	dohtml docs/*.html
	insinto /usr/share/doc/${PF}/pdf
	doins docs/libfaac.pdf
}
