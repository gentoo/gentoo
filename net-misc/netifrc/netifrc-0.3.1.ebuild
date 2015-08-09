# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd udev

DESCRIPTION="Gentoo Network Interface Management Scripts"
HOMEPAGE="http://www.gentoo.org/proj/en/base/openrc/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
	#EGIT_REPO_URI="git://github.com/gentoo/netifrc" # Alternate
	inherit git-r3
else
	SRC_URI="http://dev.gentoo.org/~robbat2/distfiles/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="kernel_linux? ( virtual/pkgconfig )
	!<sys-fs/udev-172"
RDEPEND="sys-apps/gentoo-functions"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/git.mk || die
		einfo "Producing ChangeLog from Git history"
		GIT_DIR="${S}/.git" git log >"${S}"/ChangeLog
	fi

	# Allow user patches to be applied without modifying the ebuild
	epatch_user
}

src_compile() {
	MAKE_ARGS="${MAKE_ARGS}
		UDEVDIR=${EPREFIX}$(get_udevdir)
		LIBEXECDIR=${EPREFIX}/lib/${PN} PF=${PF}"

	use prefix && MAKE_ARGS="${MAKE_ARGS} MKPREFIX=yes PREFIX=${EPREFIX}"

	emake ${MAKE_ARGS} all
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install
	dodoc README CREDITS FEATURE-REMOVAL-SCHEDULE STYLE TODO ChangeLog

	# Install the service file
	LIBEXECDIR=${EPREFIX}/lib/${PN}
	UNIT_DIR="$(systemd_get_unitdir)"
	sed "s:@LIBEXECDIR@:${LIBEXECDIR}:" "${S}/systemd/net_at.service.in" > "${T}/net_at.service" || die
	systemd_newunit "${T}/net_at.service" 'net@.service'
	dosym "${UNIT_DIR#${EPREFIX}}/net@.service" "${UNIT_DIR#${EPREFIX}}/net@lo.service"
}

pkg_postinst() {
	if [[ ! -e "${EROOT}"/etc/conf.d/net && -z $REPLACING_VERSIONS ]]; then
		elog "The network configuration scripts will use dhcp by"
		elog "default to set up your interfaces."
		elog "If you need to set up something more complete, see"
		elog "${EROOT}/usr/share/doc/${P}/README"
	fi
}
