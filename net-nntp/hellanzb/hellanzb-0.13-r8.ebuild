# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/hellanzb/hellanzb-0.13-r8.ebuild,v 1.3 2013/08/03 09:45:50 mgorny Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils eutils

DESCRIPTION="Retrieves and processes .nzb files"
HOMEPAGE="http://www.hellanzb.com/"
SRC_URI="http://www.hellanzb.com/distfiles/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="libnotify ssl"

RDEPEND=">=dev-python/twisted-core-2.0
		dev-python/twisted-web
		|| ( app-arch/unrar
			 app-arch/rar )
		app-arch/par2cmdline
		ssl? ( dev-python/pyopenssl )
		libnotify? ( dev-python/notify-python )"

DEPEND=""

DOCS="CHANGELOG CREDITS PKG-INFO README"
PYTHON_MODNAME="Hellanzb"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-datafiles.patch"
	epatch "${FILESDIR}/${P}-Fix_conf_file_search_path.patch"
	epatch "${FILESDIR}/${P}-Choose_interface_to_bind_on.patch"
	epatch "${FILESDIR}/${P}-fix_multiples_hosts.diff"
	epatch "${FILESDIR}/${P}-gettinggroup.patch"
	epatch "${FILESDIR}/${P}-python_26_fixes.patch"
	epatch "${FILESDIR}/${P}-twisted-10.0.0.patch"
}

src_install() {
	distutils_src_install

	newconfd "${FILESDIR}/hellanzb.conf" hellanzb
	newinitd "${FILESDIR}/hellanzb.init" hellanzb

	insinto etc
	doins etc/hellanzb.conf.sample
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "You can start hellanzb in the background automatically by using"
	elog "the init-script. To do this, add it to your default runlevel:"
	elog ""
	elog "    rc-update add hellanzb default"
	elog ""
	elog "Use this command to start the daemon now:"
	elog ""
	elog "    /etc/init.d/hellanzb start"
	elog ""
	elog "You will have to config /etc/conf.d/hellanzb before the init-script"
	elog "will work. It is recommended that you change the user under which"
	elog "the daemon will run."
}
