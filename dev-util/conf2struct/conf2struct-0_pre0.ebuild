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
	GIT_COMMIT="10ea3356b65e712fb000f4d37f00e1dc09c1e722"
	SRC_URI="https://github.com/yrutschle/conf2struct/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

PATCHES=(
	"${FILESDIR}/${P}-install-and-uninstall.patch"
	"${FILESDIR}/${P}-cc-and-cflags.patch"
	"${FILESDIR}/${P}-destdir.patch"
	"${FILESDIR}/${P}-install-not-run-all.patch"
	"${FILESDIR}/${P}-dest-exists.patch"
)

LICENSE="BSD-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/libconfig
	dev-perl/Conf-Libconfig"
DEPEND="${RDEPEND}"

src_install(){
	emake DESTDIR="${D}" prefix="${EPREFIX%/}/usr" install
}
