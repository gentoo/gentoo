# Copyright 2005-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/font/util.git"
DESCRIPTION="X.Org font utilities"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

XORG_CONFIGURE_OPTIONS=(
	--with-fontrootdir="${EPREFIX}/usr/share/fonts"
	--with-mapdir="${EPREFIX}/usr/share/fonts/util"
)
