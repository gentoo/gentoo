# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile-single

DESCRIPTION="Displays names/values of XDG Basedir variables"
HOMEPAGE="https://www.gnuvola.org/software/xdgdirs/"
SRC_URI="https://www.gnuvola.org/software/xdgdirs/${P}.tar.xz"

LICENSE="GPL-3+ FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	guile-single_src_prepare

	# fix shebang
	sed -i -e "/exec/ s|guile|${GUILE}|" xdgdirs.in || die
}

src_test() {
	# breaks diffs for tests if not disabled
	local -x GUILE_AUTO_COMPILE=0

	emake check
}
