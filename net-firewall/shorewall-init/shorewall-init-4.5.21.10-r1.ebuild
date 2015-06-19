# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/shorewall-init/shorewall-init-4.5.21.10-r1.ebuild,v 1.2 2015/01/13 15:54:30 jer Exp $

EAPI="5"

inherit eutils versionator prefix

MY_URL_PREFIX=
case ${P} in
	*_beta* | \
	*_rc*)
		MY_URL_PREFIX='development/'
		;;
esac

MY_PV=${PV/_rc/-RC}
MY_PV=${MY_PV/_beta/-Beta}
MY_P=${PN}-${MY_PV}

MY_MAJOR_RELEASE_NUMBER=$(get_version_component_range 1-2)
MY_MAJORMINOR_RELEASE_NUMBER=$(get_version_component_range 1-3)

DESCRIPTION="Component to secure a Shorewall-protected system at boot time prior to bringing up the network"
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="http://www1.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=sys-apps/coreutils-8.20"
RDEPEND="
	${DEPEND}
	|| ( =net-firewall/shorewall-${PVR} =net-firewall/shorewall6-${PVR} =net-firewall/shorewall-lite-${PVR} =net-firewall/shorewall6-lite-${PVR} )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/${PVR}/shorewallrc "${S}"/shorewallrc.gentoo || die "Copying shorewallrc failed"
	eprefixify "${S}"/shorewallrc.gentoo

	cp "${FILESDIR}"/${PVR}/${PN}.confd "${S}"/default.gentoo || die "Copying ${PN}.confd failed"

	cp "${FILESDIR}"/${PVR}/${PN}.initd "${S}"/init.gentoo.sh || die "Copying ${PN}.initd failed"
	eprefixify "${S}"/init.gentoo.sh

	cp "${FILESDIR}"/${PVR}/${PN}.systemd "${S}"/gentoo.service || die "Copying ${PN}.systemd failed"

	epatch "${FILESDIR}"/${PVR}/01_Remove-ipset-functionality.patch
	epatch_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	DESTDIR="${D}" ./install.sh shorewallrc.gentoo || die "install.sh failed"

	if [ -d "${D}/etc/logrotate.d" ]; then
		# On Gentoo, shorewall-init will not create shorewall-ifupdown.log,
		# so we don't need a logrotate folder at all
		rm -rf "${D}"/etc/logrotate.d
	fi

	if [ -d "${D}/etc/NetworkManager" ]; then
		# On Gentoo, we don't support NetworkManager
		# so we don't need these folder at all
		rm -rf "${D}"/etc/NetworkManager
	fi

	if [ -f "${D}/usr/share/shorewall-init/ifupdown" ]; then
		# This script won't work on Gentoo
		rm -rf "${D}"/usr/share/shorewall-init/ifupdown
	fi

	dodoc changelog.txt releasenotes.txt "${FILESDIR}"/${PVR}/README.Gentoo.txt
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Before you can use ${PN}, you need to edit its configuration in:"
		elog ""
		elog "  ${EPREFIX}/etc/conf.d/${PN}"
		elog ""
		elog "To use ${PN}, please add ${PN} to your boot runlevel:"
		elog ""
		elog "  # rc-update add ${PN} boot"
		elog ""
		ewarn "Notice:"
		ewarn "${PN} is more like a start script than a service."
		ewarn "Therefore you cannot start or stop ${PN} at default runlevel."
		ewarn ""
		ewarn "For more information read ${EPREFIX}/usr/share/doc/${PF}/README.Gentoo.txt.bz2"
	fi
}
