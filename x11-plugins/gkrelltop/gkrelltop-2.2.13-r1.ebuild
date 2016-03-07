# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="a GKrellM2 plugin which displays the top three processes"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/gkrelltop"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="X"

PLUGIN_SERVER_SO=gkrelltopd.so
PLUGIN_SO=gkrelltop.so

S="${WORKDIR}/${P}.orig"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "s:/usr/bin/gcc:$(tc-getCC) \$(CFLAGS):" \
		-e 's/-shared/$(LDFLAGS) &/' \
		Makefile || die
	default
}

src_compile() {
	use X || TARGET="server"
	emake ${TARGET}
}

pkg_postinst() {
	einfo "To enable the gkrelltopd server plugin, you must add the following"
	einfo "line to /etc/gkrellmd.conf:"
	einfo "\tplugin-enable gkrelltopd"
}
