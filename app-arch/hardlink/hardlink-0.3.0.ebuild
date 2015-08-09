# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="A tool which replaces copies of a file with hardlinks"
HOMEPAGE="http://jak-linux.org/projects/hardlink/"
SRC_URI="http://jak-linux.org/projects/${PN}/${PN}_${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-libs/libpcre"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README ${T}/README.rsync"

src_prepare() {
	sed -i -e '/^CF/s:?=:+=:' -e '/^CF/s:-O2 -g::' Makefile || die

	cat <<-EOF > "${T}"/README.rsync
	http://hardlinkpy.googlecode.com/svn/trunk/hardlink.py has regex '^\..*\.\?{6,6}$'
	for excluding rsync temporary files by default.

	To accomplish same with this version, you can use following syntax:
	# hardlink -x '^\..*\.\?{6,6}$'

	This was discussed at http://bugs.gentoo.org/416613
	EOF
}

src_compile() {
	tc-export CC
	emake
}
