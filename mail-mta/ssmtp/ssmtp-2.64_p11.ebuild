# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PATCHSET=4
WANT_AUTOMAKE=none
inherit autotools

DESCRIPTION="Extremely simple MTA to get mail off the system to a Mailhub"
HOMEPAGE="ftp://ftp.debian.org/debian/pool/main/s/ssmtp/"
SRC_URI="
	mirror://debian/pool/main/s/ssmtp/${PN}_$(ver_cut 1-2).orig.tar.bz2
	mirror://debian/pool/main/s/ssmtp/${PN}_${PV/_p/-}.debian.tar.xz
	https://dev.gentoo.org/~pinkbyte/distfiles/patches/${PN}-$(ver_cut 1-2)-patches-${MY_PATCHSET}.tar.xz
"
S="${WORKDIR}"/${PN}-$(ver_cut 1-2)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ipv6 +ssl gnutls +mta"
REQUIRED_USE="gnutls? ( ssl )"

DEPEND="
	!prefix? ( acct-group/ssmtp )
	ssl? (
		gnutls? ( net-libs/gnutls[openssl] )
		!gnutls? ( dev-libs/openssl:= )
	)
"
RDEPEND="
	${DEPEND}
	net-mail/mailbase
	mta? (
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-mta/opensmtpd
	)
"

src_prepare() {
	drop_debian_patch() {
		rm "${WORKDIR}"/debian/patches/${1} || die
		sed -i -e "/^${1}/d" "${WORKDIR}"/debian/patches/series || die
	}

	drop_gentoo_patch() {
		rm "${WORKDIR}"/patches/${1} || die
	}

	# Forces gnutls with no optionality (drops openssl support)
	drop_debian_patch 01-374327-use-gnutls.patch

	# Included in Debian patchset
	# TODO: Drop these with new patch tarball
	drop_gentoo_patch 0090_all_debian-remote-addr.patch
	drop_gentoo_patch 0100_all_ldflags.patch
	drop_gentoo_patch 0130_all_garbage-writes.patch

	PATCHES+=(
		# Debian patchset
		$(awk '{print $1}' "${WORKDIR}"/debian/patches/series | sed -e "s:^:${WORKDIR}/debian/patches/:")

		# Gentoo patchset
		"${WORKDIR}"/patches
	)

	default

	# let's start by not using configure.in anymore as future autoconf
	# versions will not support it.
	mv configure.in configure.ac || die

	eautoconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/ssmtp
		$(use_enable ssl)
		$(use_with gnutls)
		$(use_enable ipv6 inet6)
		--enable-md5auth
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake etcdir="${EPREFIX}"/etc
}

src_install() {
	dosbin ssmtp

	doman ssmtp.8 ssmtp.conf.5
	dodoc ChangeLog CHANGELOG_OLD INSTALL README TLS
	newdoc ssmtp.lsm DESC

	insinto /etc/ssmtp
	doins ssmtp.conf revaliases

	local conffile="${ED}/etc/ssmtp/ssmtp.conf"

	# Sorry about the weird indentation, I couldn't figure out a cleverer way
	# to do this without having horribly >80 char lines.
	sed -i -e "s:^hostname=:\n# Gentoo bug #47562\\
	# Commenting the following line will force ssmtp to figure\\
	# out the hostname itself.\n\\
	# hostname=:" \
	"${conffile}" || die "sed failed"

	# Comment rewriteDomain (bug #243364)
	sed -i -e "s:^rewriteDomain=:#rewriteDomain=:" "${conffile}"

	# Set restrictive perms on ssmtp.conf as per #187841, #239197
	# Protect the ssmtp configfile from being readable by regular users as it
	# may contain login/password data to auth against a the mailhub used.
	if ! use prefix; then
		fowners root:ssmtp /etc/ssmtp/ssmtp.conf
		fperms 640 /etc/ssmtp/ssmtp.conf
		fowners root:ssmtp /usr/sbin/ssmtp
		fperms 2711 /usr/sbin/ssmtp
	fi

	if use mta; then
		dosym ../sbin/ssmtp /usr/lib/sendmail
		dosym ../sbin/ssmtp /usr/bin/sendmail
		dosym ssmtp /usr/sbin/sendmail
		dosym ../sbin/ssmtp /usr/bin/mailq
		dosym ../sbin/ssmtp /usr/bin/newaliases
	fi
}
