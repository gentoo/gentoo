# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/ykclient/ykclient-2.13.ebuild,v 1.1 2014/10/06 08:03:56 jlec Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Yubico C client library"
SRC_URI="http://opensource.yubico.com/yubico-c-client/releases/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubico-c-client"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-2"
IUSE="static-libs"

RDEPEND=">=net-misc/curl-7.21.1"
DEPEND="${RDEPEND}"

# Tests require an active network connection, we don't want to run them
RESTRICT="test"
