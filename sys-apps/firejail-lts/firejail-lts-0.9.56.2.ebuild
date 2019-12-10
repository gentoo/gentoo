# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Security sandbox for any type of processes; LTS version"
HOMEPAGE="https://firejail.wordpress.com/"

MY_PN=firejail

SRC_URI="https://github.com/netblue30/${MY_PN}/archive/${PV}-LTS.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apparmor +globalcfg +network +seccomp +suid +userns test +whitelist"
RESTRICT="!test? ( test )"

DEPEND="!sys-apps/firejail
		apparmor? ( sys-libs/libapparmor )
		test? ( dev-tcltk/expect )"

RDEPEND="apparmor? ( sys-libs/libapparmor )"

S="${WORKDIR}/${MY_PN}-${PV}-LTS"

src_prepare() {
	default

	find -type f -name Makefile.in | xargs sed --in-place --regexp-extended \
		--expression='/^\tinstall .*COPYING /d' \
		--expression='/CFLAGS/s: (-O2|-ggdb) : :g' || die

	sed --in-place --regexp-extended '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable apparmor) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable seccomp) \
		$(use_enable suid) \
		$(use_enable userns) \
		$(use_enable whitelist)

}
