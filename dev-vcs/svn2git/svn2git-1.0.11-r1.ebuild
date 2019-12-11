# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils
[[ "${PV}" == "9999" ]] && inherit git-r3

DESCRIPTION="Tool for one-time conversion from svn to git"
HOMEPAGE="https://github.com/svn-all-fast-export/svn2git"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/svn-all-fast-export/svn2git.git"
else
	SRC_URI="https://github.com/svn-all-fast-export/svn2git/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""
# KEYWORDS way up

DEPEND="
	dev-qt/qtcore:5
	dev-vcs/subversion"
RDEPEND="${DEPEND}
	dev-vcs/git"

DOCS=( README.md )

PATCHES=( "${FILESDIR}"/${PN}-1.0.2.1-include-path.patch )

src_prepare() {
	# Note: patching order matters
	default

	if [[ "${PV}" != "9999" ]]; then
		eapply "${FILESDIR}"/${PN}-1.0.10-version.patch
		export SVN_ALL_FAST_EXPORT_VERSION=${PVR}  # for src_compile
	fi
}

src_configure() {
	eqmake5 fast-export2.pro
}

src_install() {
	einstalldocs
	insinto /usr/share/${PN}/samples
	doins samples/*.rules
	dobin svn-all-fast-export
	dosym svn-all-fast-export /usr/bin/svn2git
}
