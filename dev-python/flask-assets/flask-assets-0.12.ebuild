# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Flask webassets integration"
HOMEPAGE="https://github.com/miracle2k/flask-assets"
SRC_URI="https://github.com/miracle2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	>=dev-python/flask-0.8
	dev-python/webassets"
BDEPEND="
	${RDEPEND}"
