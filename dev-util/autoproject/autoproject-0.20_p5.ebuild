# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV%_p*}
DEB_VER=${PV#*_p}

DESCRIPTION="Start a programming project using autotools and a command line parser generator"
HOMEPAGE="https://packages.debian.org/unstable/devel/autoproject"
SRC_URI="
	mirror://debian/pool/main/a/autoproject/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/a/autoproject/${PN}_${MY_PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-devel/autoconf:*
	sys-devel/automake:*"
DEPEND="${RDEPEND}
	test? ( sys-apps/texinfo )"

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=( "${WORKDIR}"/${PN}_${MY_PV}-${DEB_VER}.diff )
