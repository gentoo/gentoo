# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/svn2git/svn2git-1.0.10.ebuild,v 1.4 2015/03/30 19:18:14 sping Exp $

EAPI="2"

inherit eutils qt4-r2
[ "$PV" == "9999" ] && inherit git

DESCRIPTION="Tool for one-time conversion from svn to git"
HOMEPAGE="https://github.com/svn-all-fast-export/svn2git"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/svn-all-fast-export/svn2git.git"
	KEYWORDS=""
else
	SRC_URI="https://www.hartwork.org/public/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""
# KEYWORDS way up

DEPEND="dev-vcs/subversion
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}
	dev-vcs/git"

S=${WORKDIR}/${PN}-${PN}

src_prepare() {
	# Note: patching order matters
	epatch "${FILESDIR}"/${PN}-1.0.2.1-include-path.patch
	if [[ "$PV" != "9999" ]]; then
		epatch "${FILESDIR}"/${PN}-1.0.10-version.patch
		export SVN_ALL_FAST_EXPORT_VERSION=${PVR}  # for src_compile
	fi

	qt4-r2_src_prepare
}

src_install() {
	insinto /usr/share/${PN}/samples
	doins samples/*.rules || die 'doins failed'
	dobin svn-all-fast-export || die 'dobin failed'
	dosym svn-all-fast-export /usr/bin/svn2git || die 'dosym failed'
}
