# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A lisp installer and launcher for major environment"
HOMEPAGE="https://github.com/roswell/roswell"
SRC_URI="https://github.com/roswell/roswell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"

RDEPEND="!net-libs/librouteros"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/856106
	# https://github.com/roswell/roswell/issues/584
	filter-lto

	default
}
