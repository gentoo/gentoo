# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
# eutils for einstalldocs
inherit autotools epatch epunt-cxx eutils ltprune multilib-minimal

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="http://www.audiocoding.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1 MPEG-4"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	default

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #466984

	eautoreconf
	epunt_cxx
}

multilib_src_configure() {
	local myconf=(
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf ${myconf[@]}

	# do not build the frontend for non default abis
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		sed -i -e 's/frontend//' Makefile || die
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}
