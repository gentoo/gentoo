# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Displays names/values of XDG Basedir variables"
HOMEPAGE="https://www.gnuvola.org/software/xdgdirs/"
SRC_URI="https://www.gnuvola.org/software/xdgdirs/${P}.tar.xz"

LICENSE="GPL-3+ FDL-1.3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND=">=dev-scheme/guile-1.8"
DEPEND="test? ( ${RDEPEND} )"

src_test() {
	GUILE_AUTO_COMPILE=0 emake check
}
