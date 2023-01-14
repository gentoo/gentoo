# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1

DESCRIPTION="Scopy IIO blocks for GNU Radio"
HOMEPAGE="https://github.com/analogdevicesinc/gr-scopy"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/gr-scopy.git"
	EGIT_BRANCH="3.10"
	inherit git-r3
else
	COMMIT="a69ccb22578621a69acc187fc0d006b5a030a744"
	SRC_URI="https://github.com/analogdevicesinc/gr-scopy/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	>=net-wireless/gnuradio-3.9.0.0:=[analog]
	sci-libs/volk:=
	"
DEPEND="${RDEPEND}"

src_install() {
	cmake_src_install
	python_optimize
	mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/doc/${P}"
}
