# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib

DESCRIPTION="Implements functions designed to lock the standard mailboxes"
HOMEPAGE="http://www.debian.org/"
SRC_URI="mirror://debian/pool/main/libl/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="acct-group/mail"
DEPEND="${RDEPEND}"

DOCS=( Changelog README )

PATCHES=(
	"${FILESDIR}/${PN}-1.13-makefile.patch"
)

src_prepare() {
	default

	# I don't feel like making the Makefile portable
	[[ ${CHOST} == *-darwin* ]] \
		&& cp "${FILESDIR}"/Makefile.Darwin.in Makefile.in

	eautoreconf
}

src_configure() {
	local grp=mail
	if use prefix ; then
		# we never want to use LDCONFIG
		export LDCONFIG=${EPREFIX}/bin/true
		# in unprivileged installs this is "mail"
		grp=$(id -g)
	fi
	econf --with-mailgroup=${grp} --enable-shared
}
