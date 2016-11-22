# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Transparent application input fuzzer"
HOMEPAGE="http://caca.zoy.org/wiki/zzuf"
SRC_URI="https://github.com/samhocevar/zzuf/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

# Uses dlopen hack to hijack many libc functions.
# Fails 2 tests with sandbox enabled: check-zzuf-A-autoinc check-utils
RESTRICT="test"

DOCS=( AUTHORS COPYING TODO )

src_install() {
	default

	find "${D}" -name '*.la' -delete
}
