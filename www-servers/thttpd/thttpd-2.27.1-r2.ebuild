# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

if [[ ${PV} = 9999* ]]
then
	EGIT_REPO_URI="https://github.com/blueness/sthttpd.git"
	inherit git-r3
else
	MY_P="s${P}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/blueness/sthttpd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Fork of thttpd, a small, fast, multiplexing webserver"
HOMEPAGE="https://github.com/blueness/sthttpd http://opensource.dyc.edu/sthttpd"

LICENSE="BSD GPL-2"
SLOT="0"

RDEPEND="
	acct-group/thttpd
	acct-user/thttpd
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"

WEBROOT="/var/www/localhost"

src_prepare() {
	eapply "${FILESDIR}"/thttpd-renamed-htpasswd.patch
	mv "${S}"/extras/{htpasswd.c,th_htpasswd.c} || die
	eapply_user
	eautoreconf -f -i
}

src_configure() {
	econf WEBDIR="${EPREFIX}/${WEBROOT}/htdocs"
}

src_install() {
	default

	newinitd "${FILESDIR}"/thttpd.init.1 thttpd
	newconfd "${FILESDIR}"/thttpd.confd.1 thttpd

	insinto /etc/logrotate.d
	newins "${FILESDIR}/thttpd.logrotate" thttpd

	insinto /etc/thttpd
	doins "${FILESDIR}"/thttpd.conf.sample

	# move htdocs to docdir, bug #429632
	docompress -x /usr/share/doc/"${PF}"/htdocs.dist
	mv "${ED}"/${WEBROOT}/htdocs "${ED}"/usr/share/doc/"${PF}"/htdocs.dist || die
	mkdir "${ED}"/${WEBROOT}/htdocs || die

	keepdir ${WEBROOT}/htdocs

	chown root:thttpd "${ED}/usr/sbin/makeweb" || die
	chmod 2751 "${ED}/usr/sbin/makeweb" || die
	chmod 755 "${ED}/usr/share/doc/${PF}/htdocs.dist/cgi-bin/printenv" || die
}
