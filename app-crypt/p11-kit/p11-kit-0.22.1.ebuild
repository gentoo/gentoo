# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/p11-kit/p11-kit-0.22.1.ebuild,v 1.2 2015/03/03 05:47:32 dlan Exp $

EAPI=5

inherit eutils multilib-minimal

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="http://p11-glue.freedesktop.org/p11-kit.html"
SRC_URI="http://p11-glue.freedesktop.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+asn1 debug +libffi +trust"
REQUIRED_USE="trust? ( asn1 )"

RDEPEND="asn1? ( >=dev-libs/libtasn1-3.4[${MULTILIB_USEDEP}] )
	libffi? ( >=dev-libs/libffi-3.0.0[${MULTILIB_USEDEP}] )
	trust? ( app-misc/ca-certificates )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	# disable unsafe tests, bug#502088
	export FAKED_MODE=1
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable trust trust-module) \
		$(use_with trust trust-paths ${EPREFIX}/etc/ssl/certs/ca-certificates.crt) \
		$(use_enable debug) \
		$(use_with libffi) \
		$(use_with asn1 libtasn1)

	if multilib_is_native_abi; then
		# re-use provided documentation
		ln -s "${S}"/doc/manual/html doc/manual/html || die
	fi
}

multilib_src_install_all() {
	prune_libtool_files --modules
}
