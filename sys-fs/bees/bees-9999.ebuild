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
IUSE="tools test"

RDEPEND=">=sys-apps/util-linux-2.30.2"
DEPEND="$RDEPEND
	>=sys-fs/btrfs-progs-4.1
	|| ( dev-python/markdown dev-python/markdown2 )
"

DOCS="README.md COPYING"
HTML_DOCS="README.html"

src_configure() {
	default
	localconf=${S}/localconf
	echo PREFIX=/ >${localconf} || die
	echo LIBEXEC_PREFIX=/usr/libexec >>${localconf} || die
	echo LIBDIR=$(get_libdir) >>${localconf} || die
	echo DEFAULT_MAKE_TARGET=all >>${localconf} || die
	if use tools; then
		einfo "Building with support tools fiemap and fiewalk."
		echo OPTIONAL_INSTALL_TARGETS=install_tools >>${localconf} || die
	fi
}
