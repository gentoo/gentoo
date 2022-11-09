# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Web caching proxy suitable for non-permanent Internet connections"
HOMEPAGE="https://www.gedanken.org.uk/software/wwwoffle/"
SRC_URI="https://www.gedanken.org.uk/software/${PN}/download/${P}.tgz"

KEYWORDS="amd64 ppc ppc64 ~riscv sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="gnutls ipv6 zlib"

RDEPEND="
	acct-group/wwwoffle
	acct-user/wwwoffle
	gnutls? ( net-libs/gnutls )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	dev-lang/perl
	sys-devel/flex
	${RDEPEND}
"
# Unsure whether to depend on >=www-misc/htdig-3.1.6-r4 or not

PATCHES=( "${FILESDIR}"/${PN}-2.9i-define.patch )

src_prepare() {
	default
	sed -e 's#$(TAR) xpf #$(TAR) --no-same-owner -xpf #' -i cache/Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_with gnutls)
		$(use_with ipv6)
		$(use_with zlib)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# documentation fix
	# del empty doc dirs
	rmdir "${D}/usr/doc/${PN}"/{it,nl,ru} || die
	dodir /usr/share/doc
	mv "${D}/usr/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
	rmdir "${D}/usr/doc" || die

	# install the wwwoffled init script
	newinitd "${FILESDIR}/${PN}.initd" wwwoffled
	newinitd "${FILESDIR}/${PN}-online.initd" wwwoffled-online
	newconfd "${FILESDIR}/${PN}-online.confd" wwwoffled-online

	keepdir /var/spool/wwwoffle/{http,outgoing,monitor,lasttime,lastout,local}
	for number in 1 2 3 4 5 6 7 8 9; do
		keepdir "/var/spool/wwwoffle/prevtime${number}" "/var/spool/wwwoffle/prevout${number}"
	done

	# empty dirs are removed during update
	keepdir /var/spool/wwwoffle/search/{mnogosearch/db,htdig/tmp,htdig/db-lasttime,htdig/db,namazu/db}

	touch "${D}/var/spool/wwwoffle/search/htdig/wwwoffle-htdig.log"
	touch "${D}/var/spool/wwwoffle/search/mnogosearch/wwwoffle-mnogosearch.log"
	touch "${D}/var/spool/wwwoffle/search/namazu/wwwoffle-namazu.log"

	# TODO htdig indexing as part of initscripts

	# robots.txt modification - /var/spool/wwwoffle/html/en
	# - remove Disallow: /index
	sed -e "s|Disallow:.*/index|#Disallow: /index|" -i "${D}/var/spool/wwwoffle/html/en/robots.txt" || die
}

pkg_preinst() {
	# Changing the user:group to wwwoffle:woffle
	fowners -R wwwoffle:wwwoffle /var/spool/wwwoffle /etc/wwwoffle
	sed -e 's/^[# \t]\(run-[gu]id[ \t]*=[ \t]*\)[a-zA-Z0-9]*[ \t]*$/ \1wwwoffle/g' -i "${D}/etc/wwwoffle/wwwoffle.conf" || die

}

pkg_postinst() {
	# fix permissions for those upgrading
	for number in 1 2 3 4 5 6 7 8 9;
	do
		[ ! -d "${ROOT}/var/spool/wwwoffle/prevtime${number}" ] && \
			keepdir "${ROOT}/var/spool/wwwoffle/prevtime${number}"
		[ ! -d "${ROOT}/var/spool/wwwoffle/prevout${number}" ] && \
			keepdir "${ROOT}/var/spool/wwwoffle/prevout${number}"
	done

	[ -f "${T}/stopped" ] && ewarn "wwwoffled was stopped. /etc/init.d/wwwoffled start to restart AFTER etc-update"

	einfo "wwwoffled should run as an ordinary user now. The run-uid and run-gid should be set"
	einfo "to \"wwwoffle\" in your /etc/wwwoffle/wwwoffle.conf. Please uncomment this if it hasn't been already"

	einfo "This is for your own security. Otherwise wwwoffle is run as root which is relay bad if"
	einfo "there is an exploit in this program that allows remote/local users to execute arbitary"
	einfo "commands as the root user."
}
