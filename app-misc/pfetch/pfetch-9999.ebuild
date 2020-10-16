# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dylanaraps/${PN}"
else
	SRC_URI="https://github.com/dylanaraps/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~mips ~ppc64 ~x86"
fi

DESCRIPTION="A pretty system information tool written in POSIX sh"
HOMEPAGE="https://github.com/dylanaraps/pfetch"

LICENSE="MIT"
SLOT="0"
IUSE="X"
PREFIX="/usr"


RDEPEND="X? ( x11-apps/xprop )"
BDEPEND="sys-devel/make"

src_install(){
	insinto ${PREFIX}/bin
	doins ${PN}
	fperms 755 ${PREFIX}/bin/${PN}
}
