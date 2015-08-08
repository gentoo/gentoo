# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils linux-info prefix systemd versionator

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
MY_P_DOCS=shorewall-docs-html-${MY_PV}

MY_MAJOR_RELEASE_NUMBER=$(get_version_component_range 1-2)
MY_MAJORMINOR_RELEASE_NUMBER=$(get_version_component_range 1-3)

DESCRIPTION="An iptables-based firewall whose config is handled by a normal Shorewall"
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="
	http://www1.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}/${MY_P}.tar.bz2
	doc? ( http://www1.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}/${MY_P_DOCS}.tar.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="=net-firewall/shorewall-core-${PVR}"
RDEPEND="
	${DEPEND}
	>=net-firewall/iptables-1.4.20
	>=sys-apps/iproute2-3.8.0[-minimal]
"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	local CONFIG_CHECK="~NF_CONNTRACK ~NF_CONNTRACK_IPV4"

	local ERROR_CONNTRACK="${PN} requires NF_CONNTRACK support."

	local ERROR_CONNTRACK_IPV4="${PN} requires NF_CONNTRACK_IPV4 support."

	check_extra_config
}

src_prepare() {
	cp "${FILESDIR}"/${PVR}/shorewallrc "${S}"/shorewallrc.gentoo || die "Copying shorewallrc failed"
	eprefixify "${S}"/shorewallrc.gentoo

	cp "${FILESDIR}"/${PVR}/${PN}.confd "${S}"/default.gentoo || die "Copying ${PN}.confd failed"
	cp "${FILESDIR}"/${PVR}/${PN}.initd "${S}"/init.gentoo.sh || die "Copying ${PN}.initd failed"
	cp "${FILESDIR}"/${PVR}/${PN}.systemd "${S}"/gentoo.service || die "Copying ${PN}.systemd failed"

	epatch_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	keepdir /var/lib/${PN}

	DESTDIR="${D}" ./install.sh shorewallrc.gentoo || die "install.sh failed"

	dodoc changelog.txt releasenotes.txt
	if use doc; then
		cd "${WORKDIR}/${MY_P_DOCS}"
		dohtml -r *
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Before you can use ${PN}, you need to provide a configuration, which you can"
		elog "create using ${CATEGORY}/shorewall (the full version, including the compiler)."
		elog ""
		elog "To activate ${PN} on system start, please add ${PN} to your default runlevel:"
		elog ""
		elog "  # rc-update add ${PN} default"
	fi

	if ! has_version ${CATEGORY}/shorewall-init; then
		elog ""
		elog "Starting with shorewall-lite-4.5.21.2, Gentoo also offers ${CATEGORY}/shorewall-init,"
		elog "which we recommend to install, to protect your firewall at system boot."
		elog ""
		elog "To read more about shorewall-init, please visit"
		elog "  http://www.shorewall.net/Shorewall-init.html"
	fi
}
