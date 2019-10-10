# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="83b6f9a4cf844c5c1fd5292a26cd990c58ee3962"

inherit vcs-snapshot

DESCRIPTION="Collection of commonly used Cg shaders"
HOMEPAGE="https://github.com/libretro/common-shaders"
SRC_URI="https://github.com/libretro/common-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
