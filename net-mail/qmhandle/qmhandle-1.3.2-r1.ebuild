# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Qmail message queue tool"
HOMEPAGE="http://qmhandle.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/qmhandle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa sparc x86"
IUSE=""

RDEPEND="virtual/qmail
	dev-lang/perl
	sys-process/psmisc
"
DEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.3.2-fix-help-parameter.patch"
)

src_prepare() {
	sed \
		-e 's|/usr/local/bin/svc|/usr/bin/svc|g' \
		-e 's|/service/qmail-deliver|/var/qmail/supervise/qmail-send|g' \
		-i qmHandle || die "Fixing qmHandle failed"
	default
}

src_install() {
	dodoc README HISTORY
	dobin qmHandle
}
