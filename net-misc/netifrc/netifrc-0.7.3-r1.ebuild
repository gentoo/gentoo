# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd udev

DESCRIPTION="Gentoo Network Interface Management Scripts"
HOMEPAGE="https://www.gentoo.org/proj/en/base/openrc/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/netifrc.git"
	#EGIT_REPO_URI="https://github.com/gentoo/${PN}" # Alternate
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="+dhcp"

DEPEND="!<sys-fs/udev-172"
RDEPEND="sys-apps/gentoo-functions
	>=sys-apps/openrc-0.15
	!<sys-fs/udev-init-scripts-27
	dhcp? ( || ( net-misc/dhcpcd net-misc/dhcp[client] ) )"
BDEPEND="kernel_linux? ( virtual/pkgconfig )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/git.mk || die
		einfo "Producing ChangeLog from Git history"
		GIT_DIR="${S}/.git" git log >"${S}"/ChangeLog
	fi

	default
}

src_compile() {
	MAKE_ARGS="${MAKE_ARGS}
		UDEVDIR=${EPREFIX}$(get_udevdir)
		LIBEXECDIR=${EPREFIX}/lib/${PN} PF=${PF}"

	use prefix && MAKE_ARGS+=" MKPREFIX=yes PREFIX=${EPREFIX}"

	emake ${MAKE_ARGS} all
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install
	dodoc README CREDITS FEATURE-REMOVAL-SCHEDULE STYLE TODO

	# Install the service file
	LIBEXECDIR="${EPREFIX}/lib/${PN}"
	UNIT_DIR="$(systemd_get_systemunitdir)"
	sed "s:@LIBEXECDIR@:${LIBEXECDIR}:" "${S}/systemd/net_at.service.in" > "${T}/net_at.service" || die
	systemd_newunit "${T}/net_at.service" 'net@.service'
	dosym "${UNIT_DIR#${EPREFIX}}/net@.service" "${UNIT_DIR#${EPREFIX}}/net@lo.service"
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
