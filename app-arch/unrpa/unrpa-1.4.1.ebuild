# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrpa/unrpa-1.4.1.ebuild,v 1.1 2015/04/05 12:03:11 bircoph Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lattyware/unrpa.git"
else
	SRC_URI="https://github.com/Lattyware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Ren'Py's RPA data file extractor"
HOMEPAGE="https://github.com/Lattyware/unrpa"

LICENSE="GPL-3"
SLOT="0"

DEPEND="${PYTHON_DEPS}"
RDEPEND=${DEPEND}

src_install() {
	dobin ${PN}
	dodoc README
}
