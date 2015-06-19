# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/chirp/chirp-0.4.1.ebuild,v 1.1 2014/10/08 23:45:00 zerochaos Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == "9999" ]] ; then
	SCM=mercurial
	EHG_REPO_URI="http://d-rats.com/hg/chirp.hg"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Free open-source tool for programming your amateur radio"
HOMEPAGE="http://chirp.danplanet.com"

if [[ ${PV} == "9999" ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://chirp.danplanet.com/download/${PV}/${P}.tar.gz"
	RESTRICT="test"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/pyserial
	dev-libs/libxml2[python]"
RDEPEND="${DEPEND}
	dev-python/pygtk"

src_prepare() {
	sed -i -e "/share\/doc\/chirp/d" setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	pushd tests > /dev/null
	"${PYTHON}" run_tests || die
	popd > /dev/null
}
