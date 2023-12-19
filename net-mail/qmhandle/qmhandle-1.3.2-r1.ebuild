# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Qmail message queue tool"
HOMEPAGE="http://qmhandle.sourceforge.net/"
SRC_URI="mirror://sourceforge/qmhandle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/qmail
	dev-lang/perl
	sys-process/psmisc
"
DEPEND=""

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.3.2-fix-help-parameter.patch"
	sed \
		-e 's|/usr/local/bin/svc|/usr/bin/svc|g' \
		-e 's|/service/qmail-deliver|/var/qmail/supervise/qmail-send|g' \
		-i qmHandle || die "Fixing qmHandle failed"
	eapply_user
}

src_install() {
	dodoc README HISTORY
	dobin qmHandle
}
