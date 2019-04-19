# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="https://github.com/dex4er/fakechroot"
SRC_URI="https://github.com/dex4er/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

RESTRICT="test"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f '{}' +
}
