# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A framework for managing DNS information"
HOMEPAGE="http://roy.marples.name/projects/openresolv"
SRC_URI="http://roy.marples.name/downloads/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="selinux"

DEPEND="!net-dns/resolvconf-gentoo
	!<net-dns/dnsmasq-2.40-r1"
RDEPEND="selinux? ( sec-policy/selinux-resolvconf )"

PATCHES=(
	"${FILESDIR}/3.8.1-restore-newline.patch"
)

src_configure() {
	econf \
		--prefix="${EPREFIX}" \
		--rundir="${EPREFIX}"/var/run \
		--libexecdir="${EPREFIX}"/lib/resolvconf
}

pkg_config() {
	if [[ ${ROOT} != / ]]; then
		eerror "We cannot configure unless \$ROOT=/"
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
