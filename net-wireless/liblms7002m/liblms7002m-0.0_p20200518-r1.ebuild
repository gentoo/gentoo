# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake python-any-r1

DESCRIPTION="Compact LMS7002M library suitable for resource-limited MCUs"
HOMEPAGE="https://github.com/xtrx-sdr/liblms7002m"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/xtrx-sdr/liblms7002m.git"
	inherit git-r3
else
	COMMIT="b07761b7386181f0e6a35158456b75bce14f2aca"
	SRC_URI="https://github.com/xtrx-sdr/liblms7002m/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

BDEPEND="
	$(python_gen_any_dep '
		dev-python/cheetah3[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	python_has_version "dev-python/cheetah3[${PYTHON_USEDEP}]"
}

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}
