# Copyright 2004-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps multilib

DESCRIPTION="An SMTP client and SMTP plugin for mail user agents such as Mutt"
HOMEPAGE="https://marlam.de/msmtp/"
SRC_URI="https://marlam.de/msmtp/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="daemon doc gnome-keyring idn +mta nls sasl ssl vim-syntax"

# fcaps.eclass unconditionally defines "filecaps" USE flag which we need for
# USE="daemon" in order to set the caps we need.
REQUIRED_USE="daemon? ( filecaps )"

# Upstream discourages usage of openssl. See also
# https://marlam.de/msmtp/news/openssl-discouraged/
DEPEND="
	gnome-keyring? ( app-crypt/libsecret )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )
	ssl? ( net-libs/gnutls[idn?] )
"

RDEPEND="${DEPEND}
	net-mail/mailbase
	daemon? (
		acct-group/msmtpd
		acct-user/msmtpd
	)
	mta? (
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-mta/opensmtpd
		!<mail-mta/ssmtp-2.64-r2
		!>=mail-mta/ssmtp-2.64-r2[mta]
	)
"

BDEPEND="
	doc? ( virtual/texi2dvi )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

DOCS="AUTHORS ChangeLog NEWS README THANKS doc/msmtprc*"

src_prepare() {
	# Use default Gentoo location for mail aliases
	sed 's:/etc/aliases:/etc/mail/aliases:' \
		-i scripts/find_alias/find_alias_for_msmtp.sh || die

	default
}

src_configure() {
	local myeconfargs=(
		--disable-gai-idn
		$(use_enable nls)
		$(use_with daemon msmtpd)
		$(use_with gnome-keyring libsecret)
		$(use_with idn libidn)
		$(use_with sasl libgsasl)
		$(use_with ssl tls gnutls)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc ; then
		cd doc || die
		emake html pdf
	fi
}

src_install() {
	default

	if use daemon ; then
		fcaps CAP_NET_BIND_SERVICE usr/bin/msmtpd
		newinitd "${FILESDIR}"/msmtpd.init msmtpd
		newconfd "${FILESDIR}"/msmtpd.confd msmtpd
	fi

	if use doc ; then
		dodoc doc/msmtp.{html,pdf}
	fi

	if use mta ; then
		dosym ../bin/msmtp /usr/sbin/sendmail
		dosym ../bin/msmtp /usr/$(get_libdir)/sendmail
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/vim/msmtp.vim
	fi

	insinto /etc
	newins doc/msmtprc-system.example msmtprc

	src_install_contrib find_alias find_alias_for_msmtp.sh
	src_install_contrib msmtpqueue "*.sh" "README ChangeLog"
	src_install_contrib msmtpq "msmtpq msmtp-queue" README.msmtpq
	src_install_contrib set_sendmail set_sendmail.sh set_sendmail.conf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		einfo "Please edit ${EROOT}/etc/msmtprc before first use."
		einfo "In addition, per user configuration files can be placed"
		einfo "as '~/.msmtprc'.  See the msmtprc-user.example file under"
		einfo "/usr/share/doc/${PF}/ for an example."
	fi
}

src_install_contrib() {
	subdir="$1"
	bins="$2"
	docs="$3"
	local dir=/usr/share/${PN}/${subdir}
	insinto ${dir}
	exeinto ${dir}
	for i in ${bins} ; do
		doexe scripts/${subdir}/${i}
	done
	for i in ${docs} ; do
		newdoc scripts/${subdir}/${i} ${subdir}.${i}
	done
}
