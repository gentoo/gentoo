# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF="1"

inherit eutils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-2 autotools-utils
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86"
	inherit autotools-utils
fi

DESCRIPTION="Client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.5-headers.patch
	"${FILESDIR}"/${PN}-1.9.5-implicit-internal.patch
)

src_install() {
	autotools-utils_src_install
	if use examples; then
		# --enable-examples configure switch just compiles them
		# better install sources instead
		exeinto /usr/share/doc/${PF}/examples/
		for program in $(grep PROGRAMS examples/Makefile.am | cut -d= -f2); do
			doexe examples/${program}.c
		done
	fi
}
