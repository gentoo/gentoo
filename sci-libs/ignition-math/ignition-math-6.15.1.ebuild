# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=RelWithDebInfo
inherit cmake vcs-snapshot

DESCRIPTION="A small, fast, and high performance math library for robot applications"
HOMEPAGE="https://github.com/ignitionrobotics/ign-math"
SRC_URI="https://github.com/ignitionrobotics/ign-math/archive/${PN}6_${PV}.tar.gz"
S="${WORKDIR}/${PN}6_${PV}"

LICENSE="Apache-2.0"
SLOT="6/6"
KEYWORDS="~amd64"

DEPEND="
	dev-cpp/eigen:3
	dev-build/ignition-cmake:2
"
BDEPEND="dev-build/ignition-cmake:2"
