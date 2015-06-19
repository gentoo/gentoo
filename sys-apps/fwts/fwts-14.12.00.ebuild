# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fwts/fwts-14.12.00.ebuild,v 1.2 2014/12/21 21:45:44 mrueg Exp $

EAPI=5

inherit autotools
DESCRIPTION="Firmware Test Suite"
HOMEPAGE="https://wiki.ubuntu.com/Kernel/Reference/fwts"
SRC_URI="http://fwts.ubuntu.com/release/${PN}-V${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/json-c
	dev-libs/glib:2
	dev-libs/libpcre
	sys-apps/pciutils
	sys-power/iasl
	sys-power/pmtools
	sys-apps/dmidecode"
DEPEND="${RDEPEND}
	sys-devel/libtool"

S=${WORKDIR}

src_prepare(){
	sed -i -e 's/-Wall -Werror/-Wall/' configure.ac {,src/,src/lib/src/}Makefile.am || die
	sed -i -e 's:/usr/bin/lspci:'$(type -p lspci)':' src/lib/include/fwts_binpaths.h || die

	# Fix json-c includes
	if has_version '>=dev-libs/json-c-0.10-r1'; then
		sed -e 's/^#include <json\//#include <json-c\//g' -i \
			configure.ac \
			src/acpi/syntaxcheck/syntaxcheck.c \
			src/lib/include/fwts_json.h \
			src/lib/src/fwts_klog.c \
			src/lib/src/fwts_log_json.c \
			src/utilities/kernelscan.c || die
		sed -e 's/-ljson/-ljson-c/'\
			-i src/Makefile.am\
			src/lib/src/Makefile.am\
			src/utilities/Makefile.am || die
	fi

	eautoreconf
}
