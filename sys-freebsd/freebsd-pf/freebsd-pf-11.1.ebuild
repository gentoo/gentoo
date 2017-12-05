# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bsdmk freebsd user

DESCRIPTION="FreeBSD's base system libraries"
SLOT="0"

IUSE=""

# Crypto is needed to have an internal OpenSSL header
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~x86-fbsd"
fi

EXTRACTONLY="
	usr.sbin/
	sbin/
	contrib/pf/
	etc/
"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	dev-libs/libevent
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-sources-${RV}*"

S="${WORKDIR}"

SUBDIRS="usr.sbin/authpf sbin/pfctl sbin/pflogd usr.sbin/ftp-proxy"

pkg_setup() {
	enewgroup authpf 63
}

src_prepare() {
	# pcap-int.h redefines snprintf as pcap_snprintf
	epatch "${FILESDIR}/${PN}-9.0-pcap_pollution.patch"
	# Use system's libevent
	epatch "${FILESDIR}/${PN}-11.1-libevent.patch"
	epatch "${FILESDIR}/${PN}-11.1-pflogd.patch"
	epatch "${FILESDIR}/${PN}-9.0-bpf.patch"
	# Link in kernel sources
	[[ ! -e "${WORKDIR}/sys" ]] && ln -s "/usr/src/sys" "${WORKDIR}/sys"
}

src_compile() {
	for dir in ${SUBDIRS}; do
		einfo "Starting make in ${dir}"
		cd "${S}/${dir}" || die
		freebsd_src_compile || die "Make ${dir} failed"
	done
}

src_install() {
	for dir in ${SUBDIRS}; do
		einfo "Starting install in ${dir}"
		cd "${S}/${dir}" || die
		freebsd_src_install || die "Install ${dir} failed"
	done

	cd "${WORKDIR}"/etc
	insinto /etc
	doins pf.os
	# pf.initd provided by openrc, but no pf.confd
	newconfd "${FILESDIR}/pf.confd" pf
}
