# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fdk-aac/fdk-aac-0.1.1.ebuild,v 1.6 2013/06/29 15:30:19 ago Exp $

EAPI=4

if [[ ${PV} == *9999 ]] ; then
	SCM="git"
	EGIT_REPO_URI="git://github.com/mstorsjo/${PN}.git"
	[[ ${PV%9999} != "" ]] && EGIT_BRANCH="release/${PV%.9999}"
fi

inherit eutils multilib autotools ${SCM}

DESCRIPTION="Fraunhofer AAC codec library"
HOMEPAGE="http://sourceforge.net/projects/opencore-amr/"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
elif [[ ${PV%_p*} != ${PV} ]] ; then # Gentoo snapshot
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else # Official release
	SRC_URI="mirror://sourceforge/opencore-amr/${P}.tar.gz"
fi

LICENSE="FraunhoferFDK"
SLOT="0"

[[ ${PV} == *9999 ]] || \
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd ~x64-macos"
IUSE="static-libs examples"

src_prepare() {
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--disable-dependency-tracking \
		$(use_enable examples example) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
