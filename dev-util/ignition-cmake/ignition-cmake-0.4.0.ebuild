# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="CMake modules to be used by the Ignition projects."
HOMEPAGE="https://bitbucket.org/ignitionrobotics/ign-cmake"
SRC_URI="https://osrf-distributions.s3.amazonaws.com/ign-cmake/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
