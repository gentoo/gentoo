# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Helper library for	S3TC texture (de)compression"
HOMEPAGE="https://cgit.freedesktop.org/~mareko/libtxc_dxtn/"
SRC_URI="https://people.freedesktop.org/~cbrill/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="media-libs/mesa"
RDEPEND=""

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	default

	# libtxc_dxtn is installed as a module (plugin)
	find "${D}" -name '*.la' -delete || die
}
