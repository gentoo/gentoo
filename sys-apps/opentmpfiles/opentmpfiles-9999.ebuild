# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/openrc/${PN}"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

DESCRIPTION="A standalone utility to process systemd-style tmpfiles.d files"
HOMEPAGE="https://github.com/openrc/opentmpfiles"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
