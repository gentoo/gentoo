# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 systemd toolchain-funcs

DESCRIPTION="NTP client and server programs"
HOMEPAGE="https://chrony.tuxfamily.org/"
EGIT_REPO_URI="https://git.tuxfamily.org/chrony/chrony.git/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE="caps +cmdmon ipv6 libedit +ntp +phc pps readline +refclock +rtc seccomp selinux +adns"
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
	dev-ruby/asciidoctor
	pps? ( net-misc/pps-tools )
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-chronyd )
"
RESTRICT=test
S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-systemd-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e 's:/etc/chrony\.conf:/etc/chrony/chrony.conf:g' \
		doc/* examples/* || die
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
		--chronysockdir=/run/chrony \
		--disable-sechash \
		--docdir=/usr/share/doc/${PF} \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--sysconfdir=/etc/chrony \
		--with-pidfile="${EPREFIX}/run/chrony/chronyd.pid"
		--without-nss \
		--without-tomcrypt
	"

	# print the ./configure call to aid in future debugging
	einfo ${CHRONY_CONFIGURE}
	bash ${CHRONY_CONFIGURE} || die
}

src_compile() {
	emake all docs
}

src_install() {
	default

	newinitd "${FILESDIR}"/chronyd.init-r2 chronyd
	newconfd "${FILESDIR}"/chronyd.conf chronyd

	insinto /etc/${PN}
	newins examples/chrony.conf.example1 chrony.conf

	docinto examples
	dodoc examples/*.example*

	docinto html
	dodoc doc/*.html

	keepdir /var/{lib,log}/chrony

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/chrony-2.4-r1.logrotate chrony

	systemd_dounit examples/chronyd.service
}
