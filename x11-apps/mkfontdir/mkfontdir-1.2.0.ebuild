# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="create an index of X font files in a directory"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/app/mkfontdir"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=x11-apps/mkfontscale-1.2.0"
DEPEND="${RDEPEND}"
