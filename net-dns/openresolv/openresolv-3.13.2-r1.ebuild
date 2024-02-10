# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A framework for managing DNS information"
HOMEPAGE="https://roy.marples.name/projects/openresolv"
SRC_URI="https://github.com/NetworkConfiguration/openresolv/releases/download/v${PV}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="selinux"

RDEPEND="!sys-apps/systemd[resolvconf]
	selinux? ( sec-policy/selinux-resolvconf )"

src_configure() {
	local myeconfargs=(
		--prefix="${EPREFIX}"
		--rundir="${EPREFIX}"/var/run
		--libexecdir="${EPREFIX}"/lib/resolvconf
	)
	econf "${myeconfargs[@]}"
}

pkg_config() {
	if [[ -n ${ROOT} ]]; then
		eerror "We cannot configure unless \$ROOT is empty"
		return 1
	fi

	if [[ -n "$(resolvconf -l)" ]]; then
		einfo "${PN} already has DNS information"
	else
		ebegin "Copying /etc/resolv.conf to resolvconf -a dummy"
		resolvconf -a dummy </etc/resolv.conf
		eend $? || return $?
		einfo "The dummy interface will disappear when you next reboot"
	fi
}

DOCS=( LICENSE README.md )
