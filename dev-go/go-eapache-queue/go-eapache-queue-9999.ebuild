# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-eapache-queue/go-eapache-queue-9999.ebuild,v 1.2 2015/08/05 16:43:33 williamh Exp $

EAPI=5

EGO_SRC=github.com/eapache/queue
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_SRC}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Fast golang queue using ring-buffer"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="MIT"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""
