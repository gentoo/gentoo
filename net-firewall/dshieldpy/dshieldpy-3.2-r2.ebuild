# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Python script to submit firewall logs to dshield.org"
HOMEPAGE="http://dshieldpy.sourceforge.net/"
SRC_URI="mirror://sourceforge/dshieldpy/${P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~ppc x86"

DEPEND="${PYTHON_DEPEND}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/DShield.py"

src_prepare() {
	default
	python_fix_shebang dshield.py
}

src_install() {
	default
	dobin dshield.py

	insinto /etc
	doins dshieldpy.conf
}
