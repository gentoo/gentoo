# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libtxc_dxtn/libtxc_dxtn-1.0.1.ebuild,v 1.9 2012/09/11 19:04:29 mattst88 Exp $

EAPI=4

inherit autotools-utils multilib

DESCRIPTION="Helper library for	S3TC texture (de)compression"
HOMEPAGE="http://cgit.freedesktop.org/~mareko/libtxc_dxtn/"
SRC_URI="http://people.freedesktop.org/~cbrill/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="multilib"

RDEPEND="media-libs/mesa"
DEPEND="${RDEPEND}"

RESTRICT="bindist"

foreachabi() {
	if use multilib; then
		local ABI
		for ABI in $(get_all_abis); do
			multilib_toolchain_setup ${ABI}
			AUTOTOOLS_BUILD_DIR=${WORKDIR}/${ABI} "${@}"
		done
	else
		"${@}"
	fi
}

src_configure() {
	foreachabi autotools-utils_src_configure
}

src_compile() {
	foreachabi autotools-utils_src_compile
}

src_install() {
	foreachabi autotools-utils_src_install
	find "${ED}" -name '*.la' -exec rm -f {} +
}

src_test() {
	:;
}

pkg_postinst() {
	ewarn "Depending on where you live, you might need a valid license for s3tc"
	ewarn "in order to be legally allowed to use the external library."
	ewarn "Redistribution in binary form might also be problematic."
	ewarn
	ewarn "You have been warned. Have a nice day."
}
