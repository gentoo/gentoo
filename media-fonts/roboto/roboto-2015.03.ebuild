# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/roboto/roboto-2015.03.ebuild,v 1.1 2015/03/07 12:48:31 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Standard font for Android 4.0 (Ice Cream Sandwich) and later"
HOMEPAGE="http://developer.android.com/design/style/typography.html"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"
# fonts downloaded from https://googlefontdirectory.googlecode.com/hg/apache/
# and repackaged; versioning is once again a mess

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/90-roboto-regular.conf" )
