# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils qt4-r2
[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="Tool for one-time conversion from svn to git"
HOMEPAGE="https://github.com/svn-all-fast-export/svn2git"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/svn-all-fast-export/svn2git.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/svn-all-fast-export/svn2git/archive/${PV}.tar.gz -> ${P}.tar.gz"
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
	dodoc README.md
	insinto /usr/share/${PN}/samples
	doins samples/*.rules || die 'doins failed'
	dobin svn-all-fast-export || die 'dobin failed'
	dosym svn-all-fast-export /usr/bin/svn2git || die 'dosym failed'
}
