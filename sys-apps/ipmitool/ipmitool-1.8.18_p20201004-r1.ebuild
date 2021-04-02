# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Utility for controlling IPMI enabled devices."
HOMEPAGE="http://ipmitool.sf.net/"
DEBIAN_PR="9.debian"
DEBIAN_PV="${PV/_p*}"
DEBIAN_P="${PN}_${DEBIAN_PV}"
DEBIAN_PF="${DEBIAN_P}-${DEBIAN_PR}"
COMMIT_ID=7fd7c0f2ba39e223868a8d83d81d4074f057d6fc
if [[ -n "${COMMIT_ID}" ]]; then
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
	SRC_URI="https://github.com/ipmitool/ipmitool/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi
# https://www.iana.org/assignments/enterprise-numbers/enterprise-numbers
# is not available with version numbers or dates!
SRC_URI+="
	https://dev.gentoo.org/~robbat2/distfiles/ipmitool_1.8.18-9.debian-ported-gentoo.tar.xz
	https://dev.gentoo.org/~robbat2/distfiles/enterprise-numbers.2020-10-21.xz
	"
	#http://http.debian.net/debian/pool/main/i/${PN}/${DEBIAN_PF}.tar.xz
	# https://launchpad.net/ubuntu/+archive/primary/+files/${DEBIAN_PF}.tar.xz
#IUSE="freeipmi openipmi status"
IUSE="libressl openbmc openipmi static"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~ia64 ppc ~ppc64 x86"
LICENSE="BSD"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	openbmc? ( sys-apps/systemd:0= )
	sys-libs/readline:0="
DEPEND="${RDEPEND}
		openipmi? ( sys-libs/openipmi )
		virtual/os-headers"
		#freeipmi? ( sys-libs/freeipmi )
# ipmitool CAN build against || ( sys-libs/openipmi sys-libs/freeipmi )
# but it doesn't actually need either.

PATCHES=(
	#"${FILESDIR}"/${P}-openssl-1.1.patch
)

# I hope all of this will get MUCH cleaner if upstream will just make a new
# release! - robbat2 2020/10/21
src_prepare() {
	default
	if [ -d "${S}"/debian ] ; then
		mv "${S}"/debian{,.package}
		ln -s "${WORKDIR}"/debian "${S}"
		eautoreconf
		# Upstream commit includes SOME of the debian changes, but not all of them
		sed -i \
			-e '/^#/d' \
			-e '/0120-openssl1.1.patch/d' \
			debian/patches/series
		for p in $(cat debian/patches/series) ; do
			echo ${p}
			if ! nonfatal eapply -p1 debian/patches/$p ; then
				echo "failed ${p}"
				fail=1
			fi
		done
		[[ $fail -eq 1 ]] && die "fail"
	fi
	pd="${WORKDIR}"/ipmitool_1.8.18-9.debian-ported-gentoo/
	PATCHES=(
		#"${pd}"/0000.0120-openssl1.1.patch
		"${pd}"/0001.0100-fix_buf_overflow.patch
		"${pd}"/0002.0500-fix_CVE-2011-4339.patch
		"${pd}"/0003.0600-manpage_longlines.patch
		#"${pd}"/0004.0110-getpass-prototype.patch
		#"${pd}"/0005.0115-typo.patch
		"${pd}"/0006.0125-nvidia-iana.patch
		"${pd}"/0007.0615-manpage_typo.patch
		#"${pd}"/0008.0130-Correct_lanplus_segment_violation.patch
		"${pd}"/0009.0005-gcc10.patch
		#"${pd}"/0010.0010-utf8.patch
	)
	for p in "${PATCHES[@]}" ; do
		eapply -p1 ${p} || die "failed ${p}"
	done

	eautoreconf

	# If this file is not present, then ipmitool will try to download it during make install!
	cp -al \
		"${WORKDIR}/enterprise-numbers.2020-10-21" \
		"${S}"/enterprise-numbers \
		|| die "Could not place IANA enterprise-numbers"
}

src_configure() {
	# - LIPMI and BMC are the Solaris libs
	# - OpenIPMI is unconditionally enabled in the configure as there is compat
	# code that is used if the library itself is not available
	# FreeIPMI does build now, but is disabled until the other arches keyword it
	#	`use_enable freeipmi intf-free` \
	# --enable-ipmievd is now unconditional
	WGET=/bin/true \
	CURL=/bin/true \
	econf \
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
		--bindir=/usr/sbin

	# Fix linux/ipmi.h to compile properly. This is a hack since it doesn't
	# include the below file to define some things.
	echo "#include <asm/byteorder.h>" >>config.h
}

src_install() {
	emake DESTDIR="${D}" PACKAGE="${PF}" install

	into /usr
	dosbin contrib/bmclanconf
	rm -f "${D}"/usr/share/doc/${PF}/COPYING
	docinto contrib
	cd "${S}"/contrib
	dodoc collect_data.sh create_rrds.sh create_webpage_compact.sh create_webpage.sh README

	newinitd "${FILESDIR}"/${PN}-1.8.9-ipmievd.initd ipmievd
	newconfd "${FILESDIR}"/${PN}-1.8.9-ipmievd.confd ipmievd
	# TODO: init script for contrib/bmc-snmp-proxy
	# TODO: contrib/exchange-bmc-os-info
}
