# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Core part of Paperwork (plugin management)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/distro[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
