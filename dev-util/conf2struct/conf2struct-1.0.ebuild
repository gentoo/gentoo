# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="Create C parsers for libconfig and command-line"
HOMEPAGE="https://github.com/yrutschle/conf2struct/"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/yrutschle/conf2struct.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/yrutschle/conf2struct/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/libconfig
	dev-perl/Conf-Libconfig"
DEPEND="${RDEPEND}"

src_compile(){
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install(){
	emake DESTDIR="${D}" prefix="${EPREFIX%/}/usr" install
}
