# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/fwknop.gpg
inherit autotools linux-info readme.gentoo-r1 systemd tmpfiles verify-sig

DESCRIPTION="Single Packet Authorization and Port Knocking application"
HOMEPAGE="https://www.cipherdyne.org/fwknop/"
SRC_URI="
	https://www.cipherdyne.org/fwknop/download/${P}.tar.bz2
	verify-sig? ( https://www.cipherdyne.org/fwknop/download/${P}.tar.bz2.asc )
	"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client extras firewalld gdbm gpg +iptables nfqueue +server static-libs udp-server"

DEPEND="
	client? ( net-misc/wget[ssl] )
	firewalld? ( net-firewall/firewalld )
	gdbm? ( sys-libs/gdbm )
	gpg? (
		app-crypt/gpgme:=
		dev-libs/libassuan
		dev-libs/libgpg-error
	)
	iptables? ( net-firewall/iptables )
	nfqueue? ( net-libs/libnetfilter_queue )
	server? ( !nfqueue? ( !udp-server? ( net-libs/libpcap ) ) )
	verify-sig? ( sec-keys/openpgp-keys-fwknop )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="
	nfqueue? ( server )
	server? ( ^^ ( firewalld iptables ) )
	udp-server? ( server )
"

##PATCHES=( "${FILESDIR}/${PN}-2.6.10_fno-common_fix.patch" )

DOCS=( AUTHORS ChangeLog README )

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Example configuration files were installed to '${EPREFIX}/etc/fwknopd/'.
Please edit them to suit your needs and then remove the .example suffix.

fwknopd supports several backends: firewalld, iptables, ipfw, pf, ipf.
You can set the desired backend via FIREWALL_EXE option in fwknopd.conf
instead of the default one chosen at compile time.
"

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	default_src_prepare

	# Install example configs with .example suffix.
	if use server; then
		sed -i -e 's|conf;|conf.example;|g' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}/run"
		$(use_enable client)
		$(use_enable !gdbm file-cache)
		$(use_enable nfqueue nfq-capture)
		$(use_enable server)
		$(use_enable udp-server)
		$(use_with gpg gpgme)
	)
	use firewalld && myeconfargs+=(--with-firewalld="${EPREFIX}/usr/sbin/firewalld")
	use iptables && myeconfargs+=(--with-iptables="${EPREFIX}/sbin/iptables")

	econf "${myeconfargs[@]}"
}

src_install() {
	default_src_install

	if use extras; then
		dodoc extras/apparmor/usr.sbin.fwknopd
		dodoc extras/console-qr/console-qr.sh
		dodoc extras/fwknop-launcher/*
	fi

	if use server; then
		newinitd "${FILESDIR}/fwknopd.init" fwknopd
		newconfd "${FILESDIR}/fwknopd.confd" fwknopd
		systemd_dounit extras/systemd/fwknopd.service
		newtmpfiles "${FILESDIR}/fwknopd.tmpfiles.conf" fwknopd.conf
		readme.gentoo_create_doc
	fi

	find "${ED}" -type f -name "*.la" -delete || die

	if ! use static-libs ; then
		find "${ED}" -type f -name libfko.a -delete || die
	fi
}

pkg_postinst() {
	if use server; then
		readme.gentoo_print_elog

		tmpfiles_process fwknopd.conf

		if ! linux_config_exists || ! linux_chkconfig_present NETFILTER_XT_MATCH_COMMENT; then
			echo
			ewarn "fwknopd daemon relies on the 'comment' match in order to expire"
			ewarn "created firewall rules, which is an important security feature."
			ewarn "Please enable NETFILTER_XT_MATCH_COMMENT support in your kernel."
			echo
		fi
		if use nfqueue && \
			! linux_config_exists || ! linux_chkconfig_present NETFILTER_XT_TARGET_NFQUEUE; then
			echo
			ewarn "fwknopd daemon relies on the 'NFQUEUE' target for NFQUEUE mode."
			ewarn "Please enable NETFILTER_XT_TARGET_NFQUEUE support in your kernel."
			echo
		fi
	fi
}
