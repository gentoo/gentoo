# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune multilib-minimal

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="https://p11-glue.freedesktop.org/p11-kit.html https://github.com/p11-glue/p11-kit"
SRC_URI="https://github.com/p11-glue/${PN}/releases/download/${PV}/${P}.tar.gz"

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
	einstalldocs
	prune_libtool_files --modules
}
