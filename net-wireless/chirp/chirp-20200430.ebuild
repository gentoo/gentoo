# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == "99999999" ]] ; then
	SCM=mercurial
	EHG_REPO_URI="http://d-rats.com/hg/chirp.hg"
fi

inherit distutils-r1 xdg-utils ${SCM}

DESCRIPTION="Free open-source tool for programming your amateur radio"
HOMEPAGE="http://chirp.danplanet.com"

RESTRICT="test"
if [[ ${PV} == "99999999" ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://trac.${PN}.danplanet.com/${PN}_daily/daily-${PV}/${PN}-daily-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-daily-${PV}"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE="radioreference"

DEPEND="${PYTHON_DEPS}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-libs/libxml2[python]"
RDEPEND="${DEPEND}
	dev-python/pygtk[${PYTHON_USEDEP}]
	radioreference? ( dev-python/suds[${PYTHON_USEDEP}] )"

src_prepare() {
	sed -i -e "/share\/doc\/chirp/d" setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	pushd tests > /dev/null
	"${PYTHON}" run_tests || die
	popd > /dev/null
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
