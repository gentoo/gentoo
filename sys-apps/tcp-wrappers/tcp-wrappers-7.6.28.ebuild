# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs flag-o-matic multilib-minimal usr-ldscript

MY_PV=$(ver_cut 1-2)
DEB_PV=$(ver_cut 3)
MY_P="${PN//-/_}_${MY_PV}"
DESCRIPTION="TCP Wrappers"
HOMEPAGE="http://ftp.porcupine.org/pub/security"
SRC_URI="http://ftp.porcupine.org/pub/security/${MY_P}.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${MY_PV}.q-${DEB_PV}.debian.tar.xz"

LICENSE="tcp_wrappers_license"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="ipv6 netgroups static-libs"

RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	eapply $(sed -e 's:^:../debian/patches/:' ../debian/patches/series)
	eapply "${FILESDIR}"/${PN}-7.6-redhat-bug11881.patch
	eapply "${FILESDIR}"/${PN}-7.6.28-no-external-malloc.patch

	eapply_user

	multilib_copy_sources
}

temake() {
	local mycppflags="-DHAVE_WEAKSYMS -DHAVE_STRERROR -DSYS_ERRLIST_DEFINED"
	use ipv6 && mycppflags+=" -DINET6=1 -Dss_family=__ss_family -Dss_len=__ss_len"
	emake \
		REAL_DAEMON_DIR="${EPREFIX}/usr/sbin" \
		TLI= VSYSLOG= PARANOID= BUGS= \
		AUTH="-DALWAYS_RFC931" \
		AUX_OBJ="weak_symbols.o" \
		DOT="-DAPPEND_DOT" \
		HOSTNAME="-DALWAYS_HOSTNAME" \
		NETGROUP=$(usex netgroups -DNETGROUPS "") \
		STYLE="-DPROCESS_OPTIONS" \
		LIBS=$(usex netgroups -lnsl "") \
		LIB=$(usex static-libs libwrap.a "") \
		AR="$(tc-getAR)" ARFLAGS=rc \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		COPTS="${CFLAGS} ${CPPFLAGS} ${mycppflags}" \
		LDFLAGS="${LDFLAGS}" \
		"$@"
}

multilib_src_configure() {
	tc-export AR RANLIB
	temake config-check
}

multilib_src_compile() {
	temake all
}

multilib_src_install() {
	into /usr
	use static-libs && dolib.a libwrap.a
	dolib.so shared/libwrap.so*

	insinto /usr/include
	doins tcpd.h

	if multilib_is_native_abi; then
		gen_usr_ldscript -a wrap
		dosbin tcpd tcpdchk tcpdmatch safe_finger try-from
	fi
}

multilib_src_install_all() {
	doman *.[358]
	dosym hosts_access.5 /usr/share/man/man5/hosts.allow.5
	dosym hosts_access.5 /usr/share/man/man5/hosts.deny.5

	insinto /etc
	newins "${FILESDIR}"/hosts.allow.example hosts.allow

	dodoc BLURB CHANGES DISCLAIMER README*
}

pkg_preinst() {
	# don't clobber people with our default example config
	[[ -e ${EROOT}/etc/hosts.allow ]] && cp -pP "${EROOT}"/etc/hosts.allow "${ED}"/etc/hosts.allow
}
