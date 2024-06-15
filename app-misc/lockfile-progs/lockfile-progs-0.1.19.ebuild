# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Programs to safely lock/unlock files and mailboxes"
HOMEPAGE="https://packages.debian.org/sid/lockfile-progs"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~s390 ~sparc ~x86"

DEPEND="net-libs/liblockfile"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Provide better Makefile, with clear separation between compilation
	# and installation.
	cp "${FILESDIR}/Makefile" . || die
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	# Makefile has no notion of PREFIX, bindir, and the like
	emake DESTDIR="${ED}" install
}
