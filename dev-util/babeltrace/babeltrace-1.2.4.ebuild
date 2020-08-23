# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils ltprune

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/glib:2
	dev-libs/popt
	sys-apps/util-linux
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"
src_configure() {
	econf $(use_enable test glibtest)
}

src_install() {
	default
	prune_libtool_files --all
}
