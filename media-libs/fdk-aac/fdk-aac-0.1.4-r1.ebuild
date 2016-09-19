# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/mstorsjo/${PN}.git"
	[[ ${PV%9999} != "" ]] && EGIT_BRANCH="release/${PV%.9999}"
	inherit autotools git-r3
else
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
	if [[ ${PV%_p*} != ${PV} ]]; then # Gentoo snapshot
		SRC_URI="mirror://gentoo/${P}.tar.xz"
	else # Official release
		SRC_URI="mirror://sourceforge/opencore-amr/${P}.tar.gz"
	fi
	SRC_URI+=" https://dev.gentoo.org/~soap/distfiles/${PN}-0.1.4_p20160914-fix-c++14.patch.bz2"
fi

inherit multilib-minimal

DESCRIPTION="Fraunhofer AAC codec library"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
LICENSE="FraunhoferFDK"
# subslot == N where N is libfdk-aac.so.N
SLOT="0/1"

IUSE="static-libs examples"

PATCHES=(
	# fix building with GCC 6, #585556
	"${WORKDIR}/${PN}-0.1.4_p20160914-fix-c++14.patch"
)

src_prepare() {
	default
	[[ ${PV} == *9999* ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable examples example)
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		mv "${ED%/}/usr/bin/"{,fdk-}aac-enc || die
	fi

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	use examples && einfo "aac-enc was renamed to fdk-aac-enc to prevent file collision with other packages"
}
