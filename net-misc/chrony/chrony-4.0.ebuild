# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles toolchain-funcs

DESCRIPTION="NTP client and server programs"
HOMEPAGE="https://chrony.tuxfamily.org/ https://git.tuxfamily.org/chrony/chrony.git"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.tuxfamily.org/chrony/chrony.git"
else
	SRC_URI="https://download.tuxfamily.org/${PN}/${P/_/-}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 sparc x86"
fi

S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+caps +cmdmon html ipv6 libedit +nettle +ntp +phc pps +refclock +rtc samba +seccomp +sechash selinux"
REQUIRED_USE="sechash? ( nettle )"
RESTRICT="test"

BDEPEND="nettle? ( virtual/pkgconfig )"

if [[ ${PV} == "9999" ]]; then
	# Needed for doc generation in 9999
	BDEPEND+=" virtual/w3m"
	REQUIRED_USE+=" html"
fi

DEPEND="
	caps? (
		acct-group/ntp
		acct-user/ntp
		sys-libs/libcap
	)
	libedit? ( dev-libs/libedit )
	nettle? ( dev-libs/nettle:= )
	seccomp? ( sys-libs/libseccomp )
	html? ( dev-ruby/asciidoctor )
	pps? ( net-misc/pps-tools )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-chronyd )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-pool-vendor-gentoo.patch
	"${FILESDIR}"/${PN}-3.5-r3-systemd-gentoo.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:/etc/chrony\.conf:/etc/chrony/chrony.conf:g' \
		doc/* examples/* || die

	sed -i \
		-e 's|RELOADDNS||g' \
		-e 's|pkg-config|${PKG_CONFIG}|g' \
		configure || die

	cp "${FILESDIR}"/chronyd.conf "${T}"/chronyd.conf || die
}

src_configure() {
	if ! use caps; then
		sed -i \
			-e 's/ -u ntp//' \
			"${T}"/chronyd.conf examples/chronyd.service || die
	fi

	if ! use seccomp; then
		sed -i \
			-e 's/ -F 0//' \
			"${T}"/chronyd.conf examples/chronyd.service || die
	fi

	tc-export CC PKG_CONFIG

	# Note: ncurses and nss switches are mentioned in the configure script but
	# do nothing
	# not an autotools generated script
	local myconf=(
		$(use_enable seccomp scfilter)
		$(usex caps '' --disable-linuxcaps)
		$(usex cmdmon '' --disable-cmdmon)
		$(usex ipv6 '' --disable-ipv6)
		$(usex libedit '' --without-editline)
		$(usex nettle '' --without-nettle)
		$(usex ntp '' --disable-ntp)
		$(usex phc '' --disable-phc)
		$(usex pps '' --disable-pps)
		$(usex refclock '' --disable-refclock)
		$(usex rtc '' --disable-rtc)
		$(usex samba --enable-ntp-signd '')
		$(usex sechash '' --disable-sechash)
		${EXTRA_ECONF}
		--chronysockdir="${EPREFIX}/run/chrony"
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--mandir="${EPREFIX}/usr/share/man"
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc/chrony"
		--with-hwclockfile="${EPREFIX}/etc/adjtime"
		--with-pidfile="${EPREFIX}/run/chrony/chronyd.pid"
		--without-nss
		--without-tomcrypt
	)

	# print the ./configure call
	echo sh ./configure "${myconf[@]}" >&2
	sh ./configure "${myconf[@]}" || die
}

src_compile() {
	if [[ ${PV} == "9999" ]]; then
		# uses w3m
		emake -C doc man txt
	fi

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

	systemd_dounit examples/chronyd.service
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
