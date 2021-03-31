# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="https://babeltrace.org/"
SRC_URI="https://www.efficios.com/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/glib:2
	dev-libs/popt
	dev-libs/elfutils
	sys-apps/util-linux
	"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"
src_configure() {
	econf $(use_enable test glibtest) \
		--enable-debug-info
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
