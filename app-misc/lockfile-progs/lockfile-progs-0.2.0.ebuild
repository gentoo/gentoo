# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Programs to safely lock/unlock files and mailboxes"
HOMEPAGE="https://packages.debian.org/sid/lockfile-progs"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~s390 ~sparc ~x86"

DEPEND="net-libs/liblockfile"
RDEPEND="${DEPEND}"

src_install() {
	# There's no install target in the Makefile, so copy what upstream do
	# in debian/lockfile-progs.install
	local file
	for file in lockfile-{check,create,remove,touch} mail-{lock,touchlock,unlock} ; do
		dobin bin/${file}
	done

	# ... and lockfile-progs.manpages
	for file in lockfile-{check,create,progs,remove,touch}.1 mail-{lock,touchlock,unlock}.1 ; do
		doman man/${file}
	done
}
