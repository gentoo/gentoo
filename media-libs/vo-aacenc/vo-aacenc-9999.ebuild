# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-2"
	EGIT_REPO_URI="https://github.com/mstorsjo/${PN}.git"
	[[ ${PV%9999} != "" ]] && EGIT_BRANCH="release/${PV%.9999}"
	AUTOTOOLS_AUTORECONF=yes
fi

inherit autotools-multilib flag-o-matic ${SCM}

DESCRIPTION="VisualOn AAC encoder library"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos"
IUSE="examples static-libs cpu_flags_arm_neon"

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

src_configure() {
	use cpu_flags_arm_neon && append-flags '-mfpu=neon'
	local myeconfargs=(
		"$(use_enable examples example)"
		"$(use_enable cpu_flags_arm_neon armv7neon)"
	)
	autotools-multilib_src_configure
}
