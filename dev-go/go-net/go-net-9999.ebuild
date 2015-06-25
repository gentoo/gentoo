# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-net/go-net-9999.ebuild,v 1.5 2015/06/25 19:24:07 williamh Exp $

EAPI=5
inherit golang-build golang-vcs
EGO_PN=golang.org/x/net/...
EGO_SRC=golang.org/x/net

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://godoc.org/golang.org/x/net"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-text"
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestReadProppatch(:_\0:' \
		-i src/${EGO_SRC}/webdav/xml_test.go || die
	sed -e 's:TestPingGoogle(:_\0:' \
		-e 's:TestNonPrivilegedPing(:_\0:' \
		-i src/${EGO_SRC}/icmp/ping_test.go || die
}
