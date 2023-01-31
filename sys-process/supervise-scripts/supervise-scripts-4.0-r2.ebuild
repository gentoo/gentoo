# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Starting and stopping daemontools managed services"
HOMEPAGE="http://untroubled.org/supervise-scripts/"
SRC_URI="http://untroubled.org/supervise-scripts/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="virtual/daemontools"

src_prepare() {
	echo "/usr/bin" > conf-bin
	echo "/usr/share/man" > conf-man
	default
}

src_install() {
	emake PREFIX="${D}" install
	use doc && dodoc *.html
}
