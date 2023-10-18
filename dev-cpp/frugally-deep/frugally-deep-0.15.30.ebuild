# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only library for using Keras models in C++"
HOMEPAGE="https://github.com/Dobiasd/frugally-deep"
SRC_URI="https://github.com/Dobiasd/frugally-deep/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-cpp/functional-plus
	dev-cpp/eigen
	dev-cpp/nlohmann_json
"

RDEPEND="${DEPEND}"
