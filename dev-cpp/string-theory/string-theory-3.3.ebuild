# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake ${GIT_ECLASS}

DESCRIPTION="A flexible modern C++ library for string manipulation and storage"
HOMEPAGE="https://github.com/zrax/string_theory/"

SRC_URI="https://github.com/zrax/string_theory/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/string_theory-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
