# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Eric Welsh's GUS patches for TiMidity"
HOMEPAGE="http://www.stardate.bc.ca/eawpatches/html/default.htm"
SRC_URI="http://5hdumat.samizdat.net/music/eawpats${PV}_full.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ppc ppc64 sparc x86"
RESTRICT="binchecks strip"

# These can be used for libmodplug too, so don't depend on timidity++
DEPEND="app-eselect/eselect-timidity"
RDEPEND=""

S="${WORKDIR}/eawpats"

PATCHES=( "${FILESDIR}"/${P}-fix-dir.patch )

src_install() {
	# Install documentation, including subdirs
	local f
	while IFS="" read -d $'\0' -r f; do
		dodoc "${f}"
		rm "${f}" || die
	done < <(find . -type f -name '*.txt' -print0)

	# Set our installation directory
	insinto /usr/share/timidity/eawpatches

	# Install base timidity configuration for timidity-update
	doins linuxconfig/timidity.cfg
	rm -rf linuxconfig/ winconfig/ patref24.hlp ultrasnd.ini || die

	doins -r .
}

pkg_postinst() {
	eselect timidity update --global --if-unset
}
