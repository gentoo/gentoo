# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd tmpfiles toolchain-funcs

DESCRIPTION="NTP client and server programs"
HOMEPAGE="https://chrony.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/${PN}/${P/_/-}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="
	+adns +caps +cmdmon html ipv6 libedit +ntp +phc pps readline +refclock +rtc
	+seccomp selinux
"
REQUIRED_USE="
	?? ( libedit readline )
"

CDEPEND="
	caps? ( acct-group/ntp acct-user/ntp sys-libs/libcap )
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

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-pool-vendor-gentoo.patch
	"${FILESDIR}"/${PN}-3.5-r3-systemd-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e 's:/etc/chrony\.conf:/etc/chrony/chrony.conf:g' \
		doc/* examples/* || die

	# Copy for potential user fixup
	cp "${FILESDIR}"/chronyd.conf-r1 "${T}"/chronyd.conf
	cp examples/chronyd.service "${T}"/chronyd.service

	# Set config for privdrop
	if ! use caps; then
		sed -i \
			-e 's/-u ntp//' \
			"${T}"/chronyd.conf "${T}"/chronyd.service || die
	fi

	if ! use seccomp; then
		sed -i \
			-e 's/-F 1//' \
			"${T}"/chronyd.conf "${T}"/chronyd.service || die
	fi
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
	local myconf=(
		$(use_enable seccomp scfilter)
		$(usex adns '' --disable-asyncdns)
		$(usex caps '' --disable-linuxcaps)
		$(usex cmdmon '' --disable-cmdmon)
		$(usex ipv6 '' --disable-ipv6)
		$(usex ntp '' --disable-ntp)
		$(usex phc '' --disable-phc)
		$(usex pps '' --disable-pps)
		$(usex refclock '' --disable-refclock)
		$(usex rtc '' --disable-rtc)
		${CHRONY_EDITLINE}
		${EXTRA_ECONF}
		--chronysockdir="${EPREFIX}/run/chrony"
		--disable-sechash
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--mandir="${EPREFIX}/usr/share/man"
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc/chrony"
		--with-pidfile="${EPREFIX}/run/chrony/chronyd.pid"
		--without-nss
		--without-tomcrypt
	)

	# print the ./configure call to aid in future debugging
	echo bash ./configure "${myconf[@]}" >&2
	bash ./configure "${myconf[@]}" || die
}

src_compile() {
	emake all docs $(usex html '' 'ADOC=true')
}

src_install() {
	default

	newinitd "${FILESDIR}"/chronyd.init-r2 chronyd
	newconfd "${T}"/chronyd.conf chronyd

	insinto /etc/${PN}
	newins examples/chrony.conf.example1 chrony.conf

	docinto examples
	dodoc examples/*.example*

	newtmpfiles - chronyd.conf <<<"d /run/chrony 0750 $(usex caps 'ntp ntp' 'root root')"

	if use html; then
		docinto html
		dodoc doc/*.html
	fi

	keepdir /var/{lib,log}/chrony

	if use caps; then
		# Prepare a directory for the chrony.drift file (a la ntpsec)
		# Ensures the environment is sane on new installs
		fowners ntp:ntp /var/{lib,log}/chrony
		fperms 770 /var/lib/chrony
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/chrony-2.4-r1.logrotate chrony

	systemd_dounit "${T}"/chronyd.service
	systemd_dounit examples/chrony-wait.service
	systemd_enable_ntpunit 50-chrony chronyd.service
}

pkg_preinst() {
	HAD_CAPS=false

	if has_version 'net-misc/chrony[caps]'; then
		HAD_CAPS=true
	fi
}

pkg_postinst() {
	tmpfiles_process chronyd.conf

	if [[ -n ${REPLACING_VERSIONS} ]] && use caps && ! ${HAD_CAPS}; then
		ewarn "Please adjust permissions on ${EROOT}/var/{lib,log}/chrony to be owned by ntp:ntp"
		ewarn "e.g. chown -R ntp:ntp ${EROOT}/var/{lib,log}/chrony"
		ewarn "This is necessary for chrony to drop privileges"
	fi
}
