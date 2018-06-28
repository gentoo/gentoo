# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_MULTILIB=yes
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit python-any-r1 xorg-2

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libevdev.git"

DESCRIPTION="Handler library for evdev events"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libevdev/"

if [[ ${PV} == 9999* ]] ; then
	SRC_URI=""
else
	SRC_URI="https://www.freedesktop.org/software/libevdev/${P}.tar.xz"
fi

RESTRICT="test" # Tests need to run as root.
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
