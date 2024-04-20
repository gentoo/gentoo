# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Never ending September date"
HOMEPAGE="https://www.df7cb.de/projects/sdate/"
SRC_URI="https://github.com/df7cb/sdate/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/*.la || die
}
