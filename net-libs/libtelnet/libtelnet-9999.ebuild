# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/seanmiddleditch/libtelnet.git"
else
	SRC_URI="https://github.com/seanmiddleditch/libtelnet/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple RFC-compliant TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"

LICENSE="public-domain"
SLOT="0"

# needed unconditionally for man pages
BDEPEND="app-doc/doxygen"

PATCHES=(
	# https://bugs.gentoo.org/737886
	"${FILESDIR}/${P}-doc.patch"
)
