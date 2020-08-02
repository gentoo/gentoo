# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs systemd

MY_P=${PN/-/_}-${PV}
DESCRIPTION="A utility that displays an ANSI/ASCII logo and some system information"
HOMEPAGE="http://www.deater.net/weave/vmwprod/linux_logo/"
SRC_URI="http://www.deater.net/weave/vmwprod/linux_logo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/"${P}"-configure.patch
)

DOCS=( BUGS README README.CUSTOM_LOGOS TODO USAGE LINUX_LOGO.FAQ )

S=${WORKDIR}/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/logo-config "${S}/logo_config" || die
	cp "${FILESDIR}"/linux_logo_creator "${S}/" || die
	cp "${FILESDIR}"/linux-logo.service "${S}/" || die
	cp "${FILESDIR}"/gentoo-*.logo "${S}"/logos/ || die

	sed -e 's#=$(PREFIX)#=$(DESTDIR)$(PREFIX)#' -i po/Makefile || die
	default
}

src_configure() {
	ARCH="" CC="$(tc-getCC)" AR="$(tc-getAR)" LDFLAGS="${LDFLAGS}" DESTDIR="${D}" \
		./configure --prefix=/usr || die
}

src_install() {
	default

	dobin "${FILESDIR}"/linux_logo_creator
	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	newconfd "${FILESDIR}"/${PN}-5.11.conf ${PN}

	# systemd support
	systemd_newunit "${FILESDIR}/linux-logo.service" "linux-logo.service"
}

pkg_postinst() {
	echo
	elog "Linux_logo ebuild for Gentoo comes with two Gentoo logos."
	elog ""
	elog "To display the first Gentoo logo type: linux_logo -L gentoo"
	elog "To display the second Gentoo logo type: linux_logo -L gentoo-alt"
	elog "To display all the logos available type: linux_logo -L list."
	elog ""
	elog "To start linux_logo on boot, please type:"
	elog "   rc-update add linux-logo default"
	elog "or for systemd"
	elog "   systemctl enable linux-logo.service"
	elog "which uses the settings found in"
	elog "   /etc/conf.d/linux-logo"
	echo
}

pkg_prerm() {
	# Restore issue files
	mv /etc/issue.linux-logo.backup /etc/issue 2> /dev/null
	mv /etc/issue.net.linux-logo.backup /etc/issue.net 2> /dev/null
}
