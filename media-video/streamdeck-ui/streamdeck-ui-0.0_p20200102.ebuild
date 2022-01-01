# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="A Linux compatible UI for the Elgato Stream Deck"
HOMEPAGE="https://github.com/timothycrosley/streamdeck-ui"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/timothycrosley/streamdeck-ui.git"
else
	COMMIT="9b6678d2d3027963ddac147ee3aeda322ec77f29"
	SRC_URI="https://github.com/timothycrosley/streamdeck-ui/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pynput[${PYTHON_USEDEP}]
		dev-python/pyside2[${PYTHON_USEDEP}]
		media-libs/elgato-streamdeck[${PYTHON_USEDEP}]
		dev-libs/hidapi"
RDEPEND="${DEPEND}"
