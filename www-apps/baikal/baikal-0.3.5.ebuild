# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit webapp

DESCRIPTION="Lightweight CalDAV+CardDAV server"
HOMEPAGE="http://sabre.io/baikal/"
SRC_URI="https://github.com/fruux/Baikal/releases/download/${PV}/${P}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

RDEPEND=">=dev-lang/php-5.5[ctype,filter,pdo,session,xml,xmlreader,mysql?,sqlite?]
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite )
	virtual/httpd-php"

S=${WORKDIR}/${PN}

src_install() {
	webapp_src_preinst

	dodoc *.md  || die "dodoc failed"

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r html/* html/.htaccess Core vendor || die "doins failed"

	einfo "Setting up container for configuration"
	insinto /etc/${PN}

	einfo "Fixing symlinks"
	local link target
	find "${D}${MY_HTDOCSDIR}" -type l | while read link ; do
		target=$(readlink "${link}")
		target=${target/..\/Core/Core}
		rm "${link}" && ln -s "${target}" "${link}"
	done
	dosym /etc/${PN} "${MY_HTDOCSDIR}"/Specific
	dosym . "${MY_HTDOCSDIR}"/html

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
	webapp_src_install

	if has_version www-servers/apache ; then
		fowners -R apache:apache /etc/${PN}
	elif has_version www-servers/nginx ; then
		fowners -R nginx:nginx /etc/${PN}
	else
		einfo "/etc/${PN} must be owned by the webserver user for baikal"
	fi
}
