# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~x86"
	S="${WORKDIR}/${PN}-${P}"
fi

DESCRIPTION="Client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0/13"  # sub-slot matches SONAME major
IUSE="examples static-libs utils"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_enable static-libs static)
		$(use_enable utils)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if use examples; then
		# --enable-examples configure switch just compiles them
		# better install sources instead
		exeinto /usr/share/doc/${PF}/examples/
		for program in $(grep PROGRAMS examples/Makefile.am | cut -d= -f2); do
			doexe examples/${program}.c
		done
	fi
	find "${ED}" -name "*.la" -delete || die
}
