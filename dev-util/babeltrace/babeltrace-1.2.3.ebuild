# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/babeltrace/babeltrace-1.2.3.ebuild,v 1.2 2015/05/15 13:03:19 blueness Exp $

EAPI=5

inherit eutils

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

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
