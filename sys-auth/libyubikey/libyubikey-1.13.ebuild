# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libyubikey/libyubikey-1.13.ebuild,v 1.1 2015/04/14 07:36:29 jlec Exp $

EAPI=5

inherit eutils autotools-utils

DESCRIPTION="Yubico C low-level library"
HOMEPAGE="https://github.com/Yubico/yubico-c"
#http://opensource.yubico.com/yubico-c/releases.html
SRC_URI="http://opensource.yubico.com/yubico-c/releases/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
