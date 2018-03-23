# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Statifier is a tool for creating portable, self-containing Linux executables"
HOMEPAGE="http://statifier.sourceforge.net"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="app-shells/bash
	sys-apps/coreutils
	virtual/awk"

src_prepare() {
	# Respect users CFLAGS and LDFLAGS
	sed -i -e 's/-Wall -O2/$(CFLAGS) $(LDFLAGS)/g' src/Makefile || die

	# Apply user patches
	eapply_user
}

src_configure() {
	# Fix permissions, as configure is not marked executable
	chmod +x configure || die
	econf
}

src_compile() {
	# Package complains with MAKEOPTS > -j1
	emake -j1
}

src_install() {
	# Package complains with MAKEOPTS > -j1
	emake -j1 DESTDIR="${D}" install

	# Install docs
	einstalldocs
}
