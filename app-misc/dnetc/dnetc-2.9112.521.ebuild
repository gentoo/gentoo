# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user

MAJ_PV=${PV:0:6}
MIN_PV=${PV:7:9}

DESCRIPTION="distributed.net client"
HOMEPAGE="http://www.distributed.net"
SRC_URI_BASE="http://http.distributed.net/pub/dcti/v${MAJ_PV}"
SRC_URI_x86="x86? ( ${SRC_URI_BASE}/dnetc${MIN_PV}-linux-x86-elf-uclibc.tar.gz )"
SRC_URI_arm64="arm64? ( ${SRC_URI_BASE}/dnetc${MIN_PV}-linux-arm64.tar.gz )"
SRC_URI_amd64="amd64? ( ${SRC_URI_BASE}/dnetc${MIN_PV}-linux-amd64.tar.gz )"
SRC_URI_ppc="ppc? ( ${SRC_URI_BASE}/dnetc${MIN_PV}-linux-ppc-uclibc.tar.gz )"
#SRC_URI_sparc="sparc? ( ${SRC_URI_BASE}/dnetc${MIN_PV}-linux-sparc-v7.tar.gz )"
SRC_URI="${SRC_URI_amd64} ${SRC_URI_arm64} ${SRC_URI_ppc} ${SRC_URI_x86} ${SRC_URI_sparc}"

LICENSE="distributed.net GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~x86" # sparc not available for this version
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="net-dns/bind-tools"

QA_PREBUILT="opt/distributed.net/dnetc"

case $ARCH in
	amd64) suffix=amd64 ;;
	arm64) suffix=amd64 ;;
	ppc)   suffix=ppc-elf-uclibc ;;
	x86)   suffix=x86-elf-uclibc ;;
esac
S="${WORKDIR}/dnetc${MIN_PV:0:3}-linux-${suffix}"
unset suffix

src_prepare() {
	#export S="${WORKDIR}/$(getS)"
	#echo "${S}"
	#cd "${S}"
	[[ -x dnetc ]] || die "Name of dnetc directory/binary for this platform undefined"
	eapply_user
}

src_install() {
	exeinto /opt/distributed.net
	doexe dnetc

	doman dnetc.1
	dodoc docs/CHANGES.txt docs/dnetc.txt docs/readme.*

	newinitd "${FILESDIR}"/dnetc.initd dnetc
	newconfd "${FILESDIR}"/dnetc.confd dnetc

	keepdir /var/spool/dnetc
}

pkg_preinst() {
	# This is the upstream-recommended install process
	# Flush buffers first, because the new binary might not be able to read
	# them.
	if [ -e /opt/distributed.net/dnetc ] && [ -e /etc/init.d/dnetc ]; then
		einfo "flushing old buffers"
		source /etc/conf.d/dnetc

		if [ -e /opt/distributed.net/dnetc.ini ]; then
			# use ini file
			/opt/distributed.net/dnetc -quiet -ini /opt/distributed.net/dnetc.ini -flush
		elif [ ! -e /opt/distributed.net/dnetc.ini ] && [ ! -z ${EMAIL} ]; then
			# email adress from config
			/opt/distributed.net/dnetc -quiet -flush -e ${EMAIL}
		fi

		einfo "removing old buffer files"
		rm -f /opt/distributed.net/buff*
	fi

	enewgroup dnetc
	enewuser dnetc -1 -1 /opt/distributed.net dnetc
}

pkg_postinst() {
	chown -Rf dnetc:dnetc /opt/distributed.net
	chmod 0555 /opt/distributed.net/dnetc

	elog "To run distributed.net client in the background at boot:"
	elog "   rc-update add dnetc default"
	elog ""
	elog "Either configure your email address in /etc/conf.d/dnetc"
	elog "or create the configuration file /opt/distributed.net/dnetc.ini"
}

pkg_postrm() {
	if [ -d /opt/distributed.net ]; then
		elog "All files has not been removed from /opt/distributed.net"
	fi
}
