# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

MY_RELEASEDATE="20191204"
SEPOL_VER="${PV}"
SELNX_VER="${PV}"

MY_P="${P//_/-}"
IUSE=""

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="SELinux policy module utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libsepol-${SEPOL_VER}:="

RDEPEND="${DEPEND}
	!<sys-apps/policycoreutils-2.7_pre"

src_prepare() {
	default

	sed -i 's/-Werror//g' "${S}"/*/Makefile || die "Failed to remove Werror"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" \
		install
}
