# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ram-on/imgurbash2.git"
else
	SRC_URI="https://github.com/ram-on/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Bash script that uploads/deletes images to/from imgur"
HOMEPAGE="https://github.com/ram-on/imgurbash2"

LICENSE="MIT"
SLOT="0"
IUSE="X"

RDEPEND="
	net-misc/curl
	X? ( || ( x11-misc/xclip x11-misc/xsel ) )
"

src_install() {
	einstalldocs
	dobin imgurbash2
}
