# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Transitional package to be superseded by media-libs/libv4l[utils]"
HOMEPAGE="https://git.linuxtv.org/v4l-utils.git"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+bpf dvb qt5"

RDEPEND=">=media-libs/libv4l-${PV}[utils,bpf?,dvb?,qt5?]"
