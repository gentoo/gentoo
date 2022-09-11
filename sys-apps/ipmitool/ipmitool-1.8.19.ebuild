# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Utility for controlling IPMI enabled devices"
HOMEPAGE="https://github.com/ipmitool/ipmitool"

COMMIT_ID=
if [[ -n "${COMMIT_ID}" ]]; then
	SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
else
	MY_P="${PN^^}_${PV//./_}"
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_P}"
fi

# to generate: `make enterprise-numbers` from git checkout of release tag
SRC_URI+="
	https://dev.gentoo.org/~ajak/distfiles/${CATEGORY}/${PN}/enterprise-numbers-${PV}.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="openbmc openipmi static"

RDEPEND="dev-libs/openssl:0=
	sys-libs/readline:0=
	openbmc? ( sys-apps/systemd:0= )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.69-r5
	virtual/os-headers
	openipmi? ( sys-libs/openipmi )"
	#freeipmi? ( sys-libs/freeipmi )
# ipmitool CAN build against || ( sys-libs/openipmi sys-libs/freeipmi )
# but it doesn't actually need either.

PATCHES=(
	"${FILESDIR}/${P}-missing-func-decl.patch"
	# yoinked out of debian's patchset, previously carried in a SRC_URI
	# tarball
	"${FILESDIR}/${P}-fix-buffer-overflow.patch"
	"${FILESDIR}/${P}-CVE-2011-4339.patch"
	"${FILESDIR}/${P}-manpage-longlines.patch"
	"${FILESDIR}/${P}-nvidia-iana.patch"
)

src_prepare() {
	default

	# Gentoo chooses to install ipmitool in /usr/sbin
	# Where RedHat chooses /usr/bin
	sed -i -e \
		's,/usr/bin/ipmitool,/usr/sbin/ipmitool,g' \
		"${S}"/contrib/* \
		|| die "sed bindir failed"

	eautoreconf

	# If this file is not present, then ipmitool will try to download it during make install!
	cp -al "${WORKDIR}/enterprise-numbers-${PV}" "${S}/enterprise-numbers" \
		|| die "Could not place IANA enterprise-numbers"
}

src_configure() {
	# - LIPMI and BMC are the Solaris libs
	# - OpenIPMI is unconditionally enabled in the configure as there is compat
	# code that is used if the library itself is not available
	# FreeIPMI does build now, but is disabled until the other arches keyword it
	#	`use_enable freeipmi intf-free` \
	# --enable-ipmievd is now unconditional

	local econfargs=(
		$(use_enable static) \
		--enable-ipmishell \
		--enable-intf-lan \
		--enable-intf-usb \
		$(use_enable openbmc intf-dbus) \
		--enable-intf-lanplus \
		--enable-intf-open \
		--enable-intf-serial \
		--disable-intf-bmc \
		--disable-intf-dummy \
		--disable-intf-free \
		--disable-intf-imb \
		--disable-intf-lipmi \
		--disable-internal-md5 \
		--with-kerneldir=/usr \
		--bindir=/usr/sbin \
		--runstatedir=/run \
		CFLAGS="${CFLAGS}"
	)

	econf "${econfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" PACKAGE="${PF}" install
	into /usr

	newinitd "${FILESDIR}/ipmievd.initd" ipmievd
	newconfd "${FILESDIR}/ipmievd.confd" ipmievd

	# From debian, less configurable than OpenRC
	systemd_dounit "${FILESDIR}/ipmievd.service"

	dosbin contrib/bmclanconf

	exeinto /usr/libexec
	doexe contrib/log_bmc.sh
	newinitd "${FILESDIR}/log_bmc.initd" log_bmc

	# contrib/exchange-bmc-os-info.init.redhat
	# contrib/exchange-bmc-os-info.service.redhat
	# contrib/exchange-bmc-os-info.sysconf
	exeinto /usr/libexec
	newexe contrib/exchange-bmc-os-info.init.redhat exchange-bmc-os-info

	insinto /etc/sysconfig
	newins contrib/exchange-bmc-os-info.sysconf exchange-bmc-os-info

	systemd_newunit contrib/exchange-bmc-os-info.service.redhat exchange-bmc-os-info.service
	newinitd "${FILESDIR}/exchange-bmc-os-info.initd" exchange-bmc-os-info

	# contrib/bmc-snmp-proxy
	# contrib/bmc-snmp-proxy.service
	# contrib/bmc-snmp-proxy.sysconf
	exeinto /usr/libexec
	doexe contrib/bmc-snmp-proxy

	insinto /etc/sysconfig
	newins contrib/bmc-snmp-proxy.sysconf bmc-snmp-proxy

	systemd_dounit contrib/bmc-snmp-proxy.service
	# TODO: initd for bmc-snmp-proxy

	insinto "/usr/share/${PN}"
	doins contrib/oem_ibm_sel_map

	cd "${S}/contrib"

	docinto contrib
	dodoc collect_data.sh create_rrds.sh create_webpage_compact.sh create_webpage.sh README
}
