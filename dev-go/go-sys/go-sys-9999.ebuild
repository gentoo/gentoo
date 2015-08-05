# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-sys/go-sys-9999.ebuild,v 1.6 2015/08/05 17:55:37 williamh Exp $

EAPI=5
EGO_PN=golang.org/x/sys/...
EGO_SRC=golang.org/x/sys

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
EGIT_COMMIT="58e109635f5d754f4b3a8a0172db65a52fcab866"
	SRC_URI="https://github.com/golang/sys/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go packages for low-level interaction with the operating system"
HOMEPAGE="https://godoc.org/golang.org/x/sys"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""
