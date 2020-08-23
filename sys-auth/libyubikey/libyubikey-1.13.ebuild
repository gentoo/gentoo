# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools-utils

DESCRIPTION="Yubico C low-level library"
HOMEPAGE="https://github.com/Yubico/yubico-c"
#http://opensource.yubico.com/yubico-c/releases.html
SRC_URI="http://opensource.yubico.com/yubico-c/releases/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
