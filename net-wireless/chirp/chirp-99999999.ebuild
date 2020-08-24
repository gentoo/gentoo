# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
#PYTHON_COMPAT=( python3_7 )
#DISTUTILS_SINGLE_IMPL=1

if [[ ${PV} == "99999999" ]] ; then
	SCM=mercurial
	EHG_REPO_URI="http://d-rats.com/hg/chirp.hg"
	#EHG_REVISION="py3"
else
	RESTRICT="test"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://trac.${PN}.danplanet.com/${PN}_daily/daily-${PV}/${PN}-daily-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-daily-${PV}"
fi

inherit distutils-r1 xdg-utils ${SCM}

DESCRIPTION="Free open-source tool for programming your amateur radio"
HOMEPAGE="https://chirp.danplanet.com"

LICENSE="GPL-3"
SLOT="0"
IUSE="radioreference"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-libs/libxml2[python]')"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
	python_targets_python2_7? ( dev-python/pygtk[${PYTHON_USEDEP}] )
	!python_targets_python2_7? ( dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection] )
	radioreference? ( dev-python/suds[${PYTHON_USEDEP}] )')"

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
