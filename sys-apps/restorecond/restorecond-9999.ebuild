# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

MY_RELEASEDATE="20191204"

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

DESCRIPTION="Daemon to watch for creation and set default SELinux fcontexts"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libsepol-${PV}:=
	>=sys-libs/libselinux-${PV}:=
	dev-libs/dbus-glib
	dev-libs/libpcre:=
	>=sys-libs/libcap-1.10-r10:="

RDEPEND="${DEPEND}
	!<sys-apps/policycoreutils-2.7_pre"

src_prepare() {
	default

	sed -i 's/-Werror//g' "${S}"/Makefile || die "Failed to remove Werror"
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${D}/etc/rc.d" || die

	newinitd "${FILESDIR}/restorecond.init" restorecond
}
