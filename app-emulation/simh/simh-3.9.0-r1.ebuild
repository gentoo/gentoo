# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/simh/simh-3.9.0-r1.ebuild,v 1.2 2012/11/29 11:31:35 pinkbyte Exp $

EAPI=4

inherit eutils toolchain-funcs versionator

MY_P="${PN}v$(get_version_component_range 1)$(get_version_component_range 2)-$(get_version_component_range 3)"
DESCRIPTION="a simulator for historical computers such as Vax, PDP-11 etc.)"
HOMEPAGE="http://simh.trailing-edge.com/"
SRC_URI="http://simh.trailing-edge.com/sources/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	# convert makefile from dos format to unix format
	edos2unix makefile

	epatch "${FILESDIR}"/${P}-respect-FLAGS.patch \
		"${FILESDIR}"/${P}-fix-mkdir-race.patch

	# fix linking on Darwin
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -e 's/-lrt//g' \
			-i makefile || die
	fi
}

src_compile() {
	export GCC="$(tc-getCC)"
	export LDFLAGS_O="${LDFLAGS}"
	export CFLAGS_O="${CFLAGS}"

	local my_makeopts="USE_NETWORK=1"
	if [ "$(gcc-major-version)" -le "4" -a "$(gcc-minor-version)" -lt "6" ] ; then
		my_makeopts+=" NO_LTO=1"
	fi

	emake ${my_makeopts}
}

src_install() {
	for BINFILE in BIN/* ; do
		newbin ${BINFILE} "simh-$(basename ${BINFILE})"
	done

	insinto /usr/share/simh
	doins VAX/*.bin

	dodoc *.txt */*.txt
}
