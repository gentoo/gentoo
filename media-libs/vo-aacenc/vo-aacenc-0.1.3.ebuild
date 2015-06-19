# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/vo-aacenc/vo-aacenc-0.1.3.ebuild,v 1.10 2014/08/10 09:30:17 ago Exp $

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://github.com/mstorsjo/${PN}.git"
	[[ ${PV%9999} != "" ]] && EGIT_BRANCH="release/${PV%.9999}"
	AUTOTOOLS_AUTORECONF=yes
fi

inherit autotools-multilib ${SCM}

DESCRIPTION="VisualOn AAC encoder library"
HOMEPAGE="http://sourceforge.net/projects/opencore-amr/"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
elif [[ ${PV%_p*} != ${PV} ]] ; then # Gentoo snapshot
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else # Official release
	SRC_URI="mirror://sourceforge/opencore-amr/${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0"

[[ ${PV} == *9999 ]] || \
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos"
IUSE="examples static-libs neon"

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

src_configure() {
	local myeconfargs=(
		"$(use_enable examples example)"
		"$(use_enable neon armv7neon)"
	)
	autotools-multilib_src_configure
}
