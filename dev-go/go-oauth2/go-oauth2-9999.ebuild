# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN=golang.org/x/oauth2
EGO_SRC=golang.org/x/oauth2

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="b5adcc2dcdf009d0391547edc6ecbaff889f5bb9"
	SRC_URI="https://github.com/golang/oauth2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go client implementation for OAuth 2.0 spec"
HOMEPAGE="https://godoc.org/golang.org/x/oauth2"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND="dev-go/go-net:=
	dev-go/go-tools:="
RDEPEND=""
