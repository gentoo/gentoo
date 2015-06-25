# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-oauth2/go-oauth2-9999.ebuild,v 1.1 2015/06/25 20:27:57 williamh Exp $

EAPI=5
inherit golang-build golang-vcs
EGO_PN=golang.org/x/oauth2

KEYWORDS="~amd64"
DESCRIPTION="Go client implementation for OAuth 2.0 spec"
HOMEPAGE="https://godoc.org/golang.org/x/oauth2"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net"
RDEPEND=""
