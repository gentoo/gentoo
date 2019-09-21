# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/sirupsen/logrus

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Structured, pluggable logging for Go"
HOMEPAGE="https://github.com/sirupsen/logrus"
LICENSE="MIT"
SLOT="0"
DEPEND="dev-go/go-sys:="
RDEPEND=""
