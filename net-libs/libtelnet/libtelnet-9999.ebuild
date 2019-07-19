# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/seanmiddleditch/libtelnet.git"
else
	SRC_URI="https://github.com/seanmiddleditch/libtelnet/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple RFC-complient TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"

LICENSE="public-domain"
SLOT="0"
IUSE=""

# needed unconditionally for man pages
DEPEND="app-doc/doxygen"
