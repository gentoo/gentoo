# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
DESCRIPTION="Firmware Test Suite"
HOMEPAGE="https://wiki.ubuntu.com/Kernel/Reference/fwts"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-libs/json-c-0.10-r1
	dev-libs/glib:2
	dev-libs/libpcre
	sys-apps/pciutils
	sys-power/iasl
	sys-power/pmtools
	sys-apps/dmidecode"
DEPEND="${RDEPEND}
	sys-devel/libtool"

S=${WORKDIR}

src_prepare() {
	default
	sed -i -e 's/-Wall -Werror/-Wall/' configure.ac {,src/,src/lib/src/}Makefile.am || die
	sed -i -e 's:/usr/bin/lspci:'$(type -p lspci)':' src/lib/include/fwts_binpaths.h || die

	# Fix json-c includes
	sed -e 's/^#include <json\//#include <json-c\//g' -i \
		configure.ac || die
	sed -e 's/^#include <json.h>/#include <json-c\/json.h>/' \
		-i src/lib/include/fwts_json.h \
		src/utilities/kernelscan.c || die
	sed -e 's/-ljson/-ljson-c/'\
		-i src/Makefile.am\
		src/lib/src/Makefile.am\
		src/utilities/Makefile.am || die

	eautoreconf
}
