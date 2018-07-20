# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils systemd toolchain-funcs

DESCRIPTION="NTP client and server programs"
HOMEPAGE="https://chrony.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/${PN}/${P/_/-}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="caps +cmdmon html ipv6 libedit +ntp +phc pps readline +refclock +rtc seccomp selinux +adns"
REQUIRED_USE="
	?? ( libedit readline )
"

CDEPEND="
	caps? ( sys-libs/libcap )
	libedit? ( dev-libs/libedit )
	readline? ( >=sys-libs/readline-4.1-r4:= )
	seccomp? ( sys-libs/libseccomp )
"
DEPEND="
	${CDEPEND}
	html? ( dev-ruby/asciidoctor )
	pps? ( net-misc/pps-tools )
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-chronyd )
"

RESTRICT=test

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	sed -i \
		-e 's:/etc/chrony\.:/etc/chrony/chrony.:g' \
		-e 's:/var/run:/run:g' \
		conf.c doc/*.man.in examples/* || die

	default
}

src_configure() {
	tc-export CC

	local CHRONY_EDITLINE
	# ./configure legend:
	# --disable-readline : disable line editing entirely
	# --without-readline : do not use sys-libs/readline (enabled by default)
	# --without-editline : do not use dev-libs/libedit (enabled by default)
	if ! use readline && ! use libedit; then
		CHRONY_EDITLINE='--disable-readline'
	else
		CHRONY_EDITLINE+=" $(usex readline '' --without-readline)"
		CHRONY_EDITLINE+=" $(usex libedit '' --without-editline)"
	fi

	# not an autotools generated script
	local CHRONY_CONFIGURE="
	./configure \
		$(use_enable seccomp scfilter) \
		$(usex adns '' --disable-asyncdns) \
		$(usex caps '' --disable-linuxcaps) \
		$(usex cmdmon '' --disable-cmdmon) \
		$(usex ipv6 '' --disable-ipv6) \
		$(usex ntp '' --disable-ntp) \
		$(usex phc '' --disable-phc) \
		$(usex pps '' --disable-pps) \
		$(usex refclock '' --disable-refclock) \
		$(usex rtc '' --disable-rtc) \
		${CHRONY_EDITLINE} \
		${EXTRA_ECONF} \
		--docdir=/usr/share/doc/${PF} \
		--chronysockdir=/run/chrony \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--sysconfdir=/etc/chrony \
		--disable-sechash \
		--without-nss \
		--without-tomcrypt
	"

	# print the ./configure call to aid in future debugging
	einfo ${CHRONY_CONFIGURE}
	bash ${CHRONY_CONFIGURE} || die
}

src_compile() {
	emake all docs $(usex html '' 'ADOC=true')
}

src_install() {
	default

	newinitd "${FILESDIR}"/chronyd.init-r1 chronyd
	newconfd "${FILESDIR}"/chronyd.conf chronyd

	insinto /etc/${PN}
	newins examples/chrony.conf.example1 chrony.conf

	docinto examples
	dodoc examples/*.example*

	if use html; then
		docinto html
		dodoc doc/*.html
	fi

	keepdir /var/{lib,log}/chrony

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/chrony-2.4-r1.logrotate chrony

	systemd_newunit "${FILESDIR}"/chronyd.service-r2 chronyd.service
	systemd_enable_ntpunit 50-chrony chronyd.service
}
