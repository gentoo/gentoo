# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver webapp readme.gentoo-r1

MY_PV="$(ver_rs 2 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Web-based administration for VirtualBox in PHP"
HOMEPAGE="https://sourceforge.net/projects/phpvirtualbox/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/php:*[gd,session,soap,unicode]
	virtual/httpd-php:*
"

S="${WORKDIR}/${MY_P}"

src_install() {

	local DISABLE_AUTOFORMATTING="true"
	local DOC_CONTENTS=$(sed -e "s;@@FILESDIR@@;${FILESDIR};" \
				 -e "s;@@SLOT@@;${SLOT};" "${FILESDIR}/README.gentoo")

	webapp_src_preinst

	dodoc CHANGELOG.txt README.md
	rm -f CHANGELOG.txt LICENSE.txt README.md

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php-example
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php-example

	webapp_src_install
	if has_version app-emulation/virtualbox[vboxwebsrv] || \
		has_version app-emulation/virtualbox-bin[vboxwebsrv]
	then
		newinitd "${FILESDIR}"/vboxinit-initd vboxinit-${SLOT}
	fi

	readme.gentoo_create_doc

}

pkg_postinst() {
	webapp_pkg_postinst
	readme.gentoo_print_elog
}
