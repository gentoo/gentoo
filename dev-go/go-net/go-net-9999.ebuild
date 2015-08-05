# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-net/go-net-9999.ebuild,v 1.9 2015/08/05 16:46:10 williamh Exp $

EAPI=5
EGO_PN=golang.org/x/net/...
EGO_SRC=golang.org/x/net

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="dfe268fd2bb5c793f4c083803609fce9806c6f80"
	SRC_URI="https://github.com/golang/net/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://godoc.org/golang.org/x/net"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND="dev-go/go-text:="
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestReadProppatch(:_\0:' \
		-i src/${EGO_SRC}/webdav/xml_test.go || die
	sed -e 's:TestPingGoogle(:_\0:' \
		-e 's:TestNonPrivilegedPing(:_\0:' \
		-i src/${EGO_SRC}/icmp/ping_test.go || die
}
