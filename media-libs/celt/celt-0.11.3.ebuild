# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils multilib-minimal

DESCRIPTION="CELT is a very low delay audio codec designed for high-quality communications"
HOMEPAGE="http://www.celt-codec.org/"
SRC_URI="http://downloads.us.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ogg static-libs test"

DEPEND="ogg? ( media-libs/libogg )"
RDEPEND="${DEPEND}"
DOCS=( README TODO )

src_prepare() {
	default

	if use test ; then
		# tandem tests fail:
		# https://thr3ads.net/opus/2012/09/2124778-CELT-0.11.3-tandem-test-fails
		sed '/^TESTS/s@ tandem-test@@' -i tests/Makefile.am || die
		eautoreconf
	fi
}

multilib_src_configure() {
	# ogg is for the binaries
	local myconf="--without-ogg"
	multilib_is_native_abi && myconf="$(use_with ogg ogg /usr)"

	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		${myconf}
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs
}
