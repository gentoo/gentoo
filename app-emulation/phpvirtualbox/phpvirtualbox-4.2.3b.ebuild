# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit versionator eutils webapp depend.php

MY_PV="$(replace_version_separator 2 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Web-based administration for VirtualBox in PHP"
HOMEPAGE="https://sourceforge.net/projects/phpvirtualbox/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/php[session,unicode,soap,gd]
"
DEPEND="app-arch/unzip"

need_php_httpd

src_install() {
	webapp_src_preinst

	cd ${MY_P}

	dodoc CHANGELOG.txt LICENSE.txt README.txt || die
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
}

pkg_postinst() {
	webapp_pkg_postinst
	elog "Local or remote virtualbox hosts must be compiled with"
	elog "'vboxwebsrv' useflag and the respective init script"
	elog "must be running to use this interface"
	elog " /etc/init.d/vboxwebsrv start"
	elog
	elog "To enable the automatic startup mode feature uncomment the"
	elog "following line in the config.php file:"
	elog " var \$startStopConfig = true;"
	elog
	elog "You should also add the /etc/init.d/vboxinit script to the"
	elog "default runlevel on the virtualbox host:"
	elog "\`rc-update add vboxinit default\`"
	elog "If the server is on a remote host, than the script must be"
	elog "copied manually from"
	elog "${FILESDIR}/vboxinit-initd to /etc/init.d/vboxinit"
	elog "on the remote host."
}
