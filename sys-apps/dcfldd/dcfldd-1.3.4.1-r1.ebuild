# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

My_PV=$(ver_rs 3 '-')

DESCRIPTION="enhanced dd with features for forensics and security"
HOMEPAGE="http://dcfldd.sourceforge.net/"
SRC_URI="mirror://sourceforge/dcfldd/${PN}-${My_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${WORKDIR}/${PN}-${My_PV}"
