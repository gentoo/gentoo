# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="X.Org font encodings"
HOMEPAGE="https://www.x.org/wiki/"
SRC_URI="https://www.x.org/releases/individual/font/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

BDEPEND="
	app-arch/gzip
	>=media-fonts/font-util-1.1.1-r1
	x11-apps/mkfontscale
"

ECONF_SOURCE="${S}"
