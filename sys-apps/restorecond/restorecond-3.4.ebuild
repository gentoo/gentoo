# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd toolchain-funcs

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~mips x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Daemon to watch for creation and set default SELinux fcontexts"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-libs/glib:2
	>=sys-libs/libsepol-${PV}:=
	>=sys-libs/libselinux-${PV}:="

RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i 's/-Werror//g' "${S}"/Makefile || die "Failed to remove Werror"
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	emake DESTDIR="${D}" \
		SYSTEMDSYSTEMUNITDIR="$(systemd_get_systemunitdir)" \
		SYSTEMDUSERUNITDIR=$(systemd_get_userunitdir) \
		install

	rm -rf "${D}/etc/rc.d" || die

	newinitd "${FILESDIR}/restorecond.init" restorecond
}
