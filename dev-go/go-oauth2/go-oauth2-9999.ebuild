# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-oauth2/go-oauth2-9999.ebuild,v 1.2 2015/06/29 14:25:31 williamh Exp $

EAPI=5
inherit golang-build golang-vcs
EGO_PN=golang.org/x/oauth2

DESCRIPTION="Go client implementation for OAuth 2.0 spec"
HOMEPAGE="https://godoc.org/golang.org/x/oauth2"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net"
RDEPEND=""
