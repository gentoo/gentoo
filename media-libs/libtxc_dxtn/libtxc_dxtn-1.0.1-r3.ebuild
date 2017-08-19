# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune multilib-minimal

DESCRIPTION="Helper library for	S3TC texture (de)compression"
HOMEPAGE="https://cgit.freedesktop.org/~mareko/libtxc_dxtn/"
SRC_URI="https://people.freedesktop.org/~cbrill/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/mesa"
DEPEND="${RDEPEND}"

RESTRICT="bindist"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	default

	# libtxc_dxtn is installed as a module (plugin)
	prune_libtool_files --all
}

pkg_postinst() {
	ewarn "Depending on where you live, you might need a valid license for s3tc"
	ewarn "in order to be legally allowed to use the external library."
	ewarn "Redistribution in binary form might also be problematic."
	ewarn
	ewarn "You have been warned. Have a nice day."
}
