# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="Gentoo Network Interface Management Scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Netifrc"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/netifrc.git
		https://github.com/gentoo/${PN}
	"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="BSD-2 GPL-2"
SLOT="0"
IUSE="+dhcp"

RDEPEND="
	sys-apps/gentoo-functions
	>=sys-apps/openrc-0.15
	dhcp? (
		|| (
			net-misc/dhcpcd
			net-misc/dhcp[client]
			sys-apps/busybox
		)
	)
"
BDEPEND="
	kernel_linux? ( virtual/pkgconfig )
"

src_prepare() {
	if [[ ${PV} == 9999 ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/git.mk || die
		einfo "Producing ChangeLog from Git history"
		GIT_DIR="${S}/.git" git log >"${S}"/ChangeLog
	fi

	default
}

src_compile() {
	MAKE_ARGS=(
		PREFIX="${EPREFIX}"
		UPREFIX="${EPREFIX}/usr"
		UDEVDIR="${EPREFIX}$(get_udevdir)"
		LIBEXECDIR="${EPREFIX}/lib/${PN}"
		PF="${PF}"
	)

	emake "${MAKE_ARGS[@]}" all
}

src_install() {
	emake "${MAKE_ARGS[@]}" DESTDIR="${D}" install
	dodoc README CREDITS FEATURE-REMOVAL-SCHEDULE STYLE TODO

	# Install the service file
	local LIBEXECDIR="${EPREFIX}/lib/${PN}"
	sed "s:@LIBEXECDIR@:${LIBEXECDIR}:" "${S}/systemd/net_at.service.in" > "${T}/net_at.service" || die
	systemd_newunit "${T}/net_at.service" 'net@.service'

	local UNIT_DIR="$(systemd_get_systemunitdir)"
	UNIT_DIR="${UNIT_DIR#"${EPREFIX}"}"
	dosym net@.service "${UNIT_DIR}/net@lo.service"
}

pkg_postinst() {
	udev_reload

	if [[ ! -e "${EROOT}"/etc/conf.d/net && -z ${REPLACING_VERSIONS} ]]; then
		elog "The network configuration scripts will use dhcp by"
		elog "default to set up your interfaces."
		elog "If you need to set up something more complete, see"
		elog "${EROOT}/usr/share/doc/${P}/README"
	fi
}

pkg_postrm() {
	udev_reload
}
