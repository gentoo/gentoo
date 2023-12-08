# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

MY_PN="phpLDAPadmin"
DESCRIPTION="phpLDAPadmin is a web-based tool for managing all aspects of your LDAP server"
HOMEPAGE="https://github.com/leenooks/phpLDAPadmin"
SRC_URI="https://github.com/leenooks/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-lang/php-8.0[hash(+),ldap,session,xml,nls]
	dev-libs/openssl
	virtual/httpd-php
"
BDEPEND="
	media-libs/libpng
"
S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.1.1-fix-magic-quotes.patch"
	"${FILESDIR}/${PN}-1.2.6.4-getDN-htmlspecialchars.patch"
)

need_httpd_cgi

src_prepare() {
	mv config/config.php.example config/config.php || die
	default
	# fix QA notice about broken IDAT window length
	pngfix --out=network.png htdocs/images/default/network.png; [[ $? -lt 16 ]] || die
	pngfix --out=document.png htdocs/images/default/document.png; [[ $? -lt 16 ]] || die
	mv -f network.png document.png htdocs/images/default/ || die
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL.md

	# Restrict config file access - bug 280836
	chown root:apache "config/config.php"
	chmod 640 "config/config.php"

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	webapp_configfile "${MY_HTDOCSDIR}/config/config.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall2-en.txt

	webapp_src_install
}
