# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Transparent ftp proxy"
HOMEPAGE="https://frox.sourceforge.net/"
SRC_URI="https://frox.sourceforge.net/download/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="clamav ssl transparent"

DEPEND="
	acct-group/ftpproxy
	acct-user/ftpproxy
	clamav? ( >=app-antivirus/clamav-0.80 )
	kernel_linux? ( >=sys-kernel/linux-headers-2.6 )
	ssl? (
		dev-libs/openssl:0=
	)
"

RDEPEND="${DEPEND}"

# INSTALL has useful filewall rules
DOCS=(
	BUGS README
	doc/CREDITS doc/ChangeLog doc/FAQ doc/INSTALL
	doc/INTERNALS doc/README.transdata doc/RELEASE
	doc/SECURITY doc/TODO
)

pkg_setup() {
	use clamav && ewarn "Virus scanner potentialy broken in chroot - see bug #81035"
}

src_prepare() {
	HTML_DOCS=( doc/*.html doc/*.sgml )

	default

	eapply "${FILESDIR}/${PV}-respect-CFLAGS.patch"
	eapply "${FILESDIR}/${PV}-netfilter-includes.patch"
	eapply "${FILESDIR}/${P}-config.patch"
	eapply "${FILESDIR}/${P}-no-common.patch"

	if use clamav ; then
		sed -e "s:^# VirusScanner.*:# VirusScanner '\"/usr/bin/clamscan\" \"%s\"':" \
			-i "src/${PN}.conf" || die
	fi

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-http-cache --enable-local-cache
		--enable-procname
		--enable-configfile=/etc/frox.conf
		$(use_enable !kernel_linux libiptc)
		$(use_enable clamav virus-scan)
		$(use_enable ssl)
		$(use_enable transparent transparent-data)
		$(use_enable !transparent ntp)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	keepdir /var/log/"${PN}"

	fowners ftpproxy:ftpproxy /var/log/frox

	newman "doc/${PN}.man" "${PN}.man.8"
	newman "doc/${PN}.conf.man" "${PN}.conf.man.5"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	insinto /etc
	newins "src/${PN}.conf" "${PN}.conf.example"
}
