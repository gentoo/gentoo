# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
FORTRAN_STANDARD="2003"

inherit cmake fortran-2

MY_PN="OpenCoarrays"

DESCRIPTION="A parallel application binary interface for Fortran 2018 compilers"
HOMEPAGE="http://www.opencoarrays.org/"
SRC_URI="https://github.com/sourceryinstitute/${MY_PN}/releases/download/${PV}/${MY_PN}-${PV}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests fail with FEATURES="network-sandbox" for most versions of openmpi and mpich it with error:
# "No network interfaces were found for out-of-band communications.
#  We require at least one available network for out-of-band messaging."
IUSE="test"
PROPERTIES="test_network"
RESTRICT="!test? ( test )"

RDEPEND="
	|| ( >=sys-cluster/openmpi-4.1.2[fortran] >=sys-cluster/mpich-3.4.3[fortran,mpi-threads,threads] )
"
DEPEND="
	${RDEPEND}
"
