# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit obs-service

IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
	app-arch/unzip
	app-arch/xz-utils
"
