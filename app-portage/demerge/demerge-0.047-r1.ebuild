# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/demerge/demerge-0.047-r1.ebuild,v 1.8 2013/02/01 00:26:15 mr_bones_ Exp $

DESCRIPTION="demerge - revert to previous installation states"
HOMEPAGE="http://download.mpsna.de/opensource/demerge/"
SRC_URI="http://download.mpsna.de/opensource/demerge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~ppc64 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl
		>=dev-perl/PortageXS-0.02.10-r3
		virtual/perl-Term-ANSIColor
		dev-perl/TermReadKey
		dev-perl/Shell-EnvImporter"
RDEPEND="${DEPEND}
		sys-apps/portage"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix path for new make.conf location
	sed -i -e 's:/etc/make.conf:/etc/portage/make.conf:g' demerge
}

src_install() {
	dobin demerge || die
	dodoc Changelog
	doman demerge.3
}

pkg_postinst() {
	if [ ! -e /etc/portage/postsync.d/demerge-record ]; then
		mkdir -p /etc/portage/postsync.d/
		echo '[ -x /usr/bin/demerge ] && /usr/bin/demerge --postsync' > /etc/portage/postsync.d/demerge-record
		elog "/etc/portage/postsync.d/demerge-record has been installed for convenience"
		elog "If you wish for it to be automatically run at the end of every --sync simply chmod +x /etc/portage/postsync.d/demerge-record"
		elog "If ever you find this to be an inconvenience simply chmod -x /etc/portage/postsync.d/demerge-record"
	fi
}
