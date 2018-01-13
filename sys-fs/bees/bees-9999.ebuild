# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Best-Effort Extent-Same, a btrfs dedup agent"
HOMEPAGE="https://github.com/Zygo/bees"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/kakra/bees.git"
	EGIT_BRANCH="integration"
	inherit git-r3
else
	SRC_URI="https://github.com/Zygo/bees/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

PATCHES="${FILESDIR}/v0.5-gentoo_build.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=sys-apps/util-linux-2.30.2
	>=sys-devel/gcc-4.9
	>=sys-fs/btrfs-progs-4.1
"
DEPEND="$RDEPEND
	|| ( dev-python/markdown dev-python/markdown2 )
"

DOCS="README.md COPYING"
HTML_DOCS="README.html"

src_configure() {
	default
	echo PREFIX=/ >${S}/localconf || die
	echo LIBEXEC_PREFIX=/usr/libexec >>${S}/localconf || die
	echo LIBDIR=$(get_libdir) >>${S}/localconf || die
}
