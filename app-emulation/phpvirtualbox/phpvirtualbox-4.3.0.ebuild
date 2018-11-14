# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit versionator eutils webapp readme.gentoo

MY_PV="$(replace_version_separator 2 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Web-based administration for VirtualBox in PHP"
HOMEPAGE="https://sourceforge.net/projects/phpvirtualbox/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/php[session,unicode,soap,gd]
	virtual/httpd-php:*
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Local or remote virtualbox hosts must be compiled with
'vboxwebsrv' useflag and the respective init script
must be running to use this interface:
/etc/init.d/vboxwebsrv start

To enable the automatic startup mode feature uncomment the
following line in the config.php file:
var \$startStopConfig = true;

You should also add the /etc/init.d/vboxinit script to the
default runlevel on the virtualbox host:
\`rc-update add vboxinit default\`
If the server is on a remote host, than the script must be
copied manually from
'${FILESDIR}'/vboxinit-initd to
/etc/init.d/vboxinit on the remote host."

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.txt LICENSE.txt README.txt
	rm -f CHANGELOG.txt LICENSE.txt README.txt

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php-example
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php-example

	webapp_src_install
	if has_version app-emulation/virtualbox[vboxwebsrv] || \
		has_version app-emulation/virtualbox-bin[vboxwebsrv]
	then
		newinitd "${FILESDIR}"/vboxinit-initd vboxinit
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	webapp_pkg_postinst
	readme.gentoo_print_elog
}
