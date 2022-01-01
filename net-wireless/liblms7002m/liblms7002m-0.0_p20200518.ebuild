# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake python-single-r1

DESCRIPTION="Toolkit that provides signal processing blocks to implement software radios"
HOMEPAGE="https://www.gnuradio.org/"
LICENSE="GPL-3"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/xtrx-sdr/liblms7002m.git"
	inherit git-r3
else
	COMMIT="b07761b7386181f0e6a35158456b75bce14f2aca"
	SRC_URI="https://github.com/xtrx-sdr/liblms7002m/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

RDEPEND="${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/cheetah3[${PYTHON_USEDEP}]')"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}
