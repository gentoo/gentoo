# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/parallel/parallel-20150522.ebuild,v 1.1 2015/05/27 01:09:26 robbat2 Exp $

EAPI=5

DESCRIPTION="A shell tool for executing jobs in parallel locally or on remote machines"
HOMEPAGE="http://www.gnu.org/software/parallel/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/Devel-Size
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-IO"
# moreutils for `parallel` and grass for 'sql.1' manpage
DEPEND="${RDEPEND}
	!<sys-apps/moreutils-0.45-r1
	!<sci-geosciences/grass-6.4.1-r1"

DOCS="NEWS README"

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default

	# See src/Makefile.am for this one:
	rm -f "${ED}"usr/bin/sem
	dosym ${PN} /usr/bin/sem
}

pkg_postinst() {
	elog "To distribute jobs to remote machines you'll need these dependencies"
	elog " net-misc/openssh"
	elog " net-misc/rsync"
}
