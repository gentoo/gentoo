# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Sets up Hierachical Token Bucket based traffic control (QoS) with iproute2"
HOMEPAGE="https://sourceforge.net/projects/htbinit/"
SRC_URI="mirror://sourceforge/htbinit/htb.init-v${PV}"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="esfq ipv6"

DEPEND="sys-apps/iproute2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/htb.init-v0.8.5_tos.patch
	"${FILESDIR}"/prio_rule.patch
	"${FILESDIR}"/timecheck_fix.patch
	"${FILESDIR}"/htb.init_find_fix.patch
)

pkg_setup() {
	local i
	for i in NET_SCH_HTB NET_SCH_SFQ NET_CLS_FW NET_CLS_U32 NET_CLS_ROUTE4 ; do
		CONFIG_CHECK="${CONFIG_CHECK} ~${i}"
	done

	use esfq && CONFIG_CHECK="${CONFIG_CHECK} ~NET_SCH_ESFQ"
	linux-info_pkg_setup
}

src_unpack() {
	cp "${DISTDIR}"/htb.init-v${PV} "${S}"/htb.init || die
}

src_prepare() {
	default

	sed -i 's|/etc/sysconfig/htb|/etc/htb|g' "${S}"/htb.init || die

	use esfq && eapply "${FILESDIR}"/htb_0.8.5_esfq.patch
	use ipv6 && eapply "${FILESDIR}"/htb_0.8.5_ipv6.patch

	# bug #474700
	sed -i -e 's:/sbin/ip:/bin/ip:g' "${S}"/htb.init || die
}

src_compile() {
	:
}

src_install() {
	dosbin htb.init

	newinitd "${FILESDIR}"/htbinit.rc htbinit

	keepdir /etc/htb
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog 'Run "rc-update add htbinit default" to run htb.init at startup.'
		elog 'Please, read carefully the htb.init documentation.'
		elog 'New directory to store configuration is /etc/htb.'
	fi
}
