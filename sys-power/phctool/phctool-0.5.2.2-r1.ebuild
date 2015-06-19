# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/phctool/phctool-0.5.2.2-r1.ebuild,v 1.4 2012/05/24 05:46:22 vapier Exp $

EAPI=2

PYTHON_DEPEND="2"
inherit eutils python user

DESCRIPTION="Processor Hardware Control userland configuration tool"
HOMEPAGE="http://www.linux-phc.org/"
SRC_URI="http://www.linux-phc.org/forum/download/file.php?id=50 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sudo"

RDEPEND="dev-python/egg-python
	dev-python/pygtk:2
	sudo? ( app-admin/sudo )"

S="${WORKDIR}/${PV%.*}-${PV##*.}/${PN}"

pkg_setup() {
	MY_PROGDIR="/usr/share/${PN}"
	if use sudo ; then
		MY_GROUPNAME="phcusers"
		enewgroup ${MY_GROUPNAME}
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}_all_paths_tray.patch"
	if use sudo; then
		epatch "${FILESDIR}/${P}_all_paths_tool_sudo.patch"
	else
		epatch "${FILESDIR}/${P}_all_paths_tool_no_sudo.patch"
	fi
	epatch "${FILESDIR}/${P}_kernel_2.6.36.patch"
	find . -name "*.pyc" -exec rm {} +
}

src_install() {
	newbin phctool.sh phctool || die
	newbin phctray.sh phctray || die

	exeinto ${MY_PROGDIR}
	doexe phc{tool,tray}.py subphctool.sh || die
	insinto ${MY_PROGDIR}
	doins -r inc || die

	if use sudo ; then
		fowners -R :${MY_GROUPNAME} "${MY_PROGDIR}" || die
		fperms g+rX "${MY_PROGDIR}" || die
	fi

	dodoc CHANGELOG || die
	if use doc; then
		dohtml -r doc/docfiles doc/index.htm || die
	fi
}

pkg_postinst() {
	if use sudo; then
		einfo "You have to add a line to /etc/sudoers to get access to"
		einfo "/sys/devices/system/cpu/cpu1/cpufreq/phc_controls from the phctool/phctray"
		einfo "Please check following line and add it to /etc/sudoser using visudo:"
		einfo "  %${MY_GROUPNAME} ALL=(root) NOPASSWD:${MY_PROGDIR}/subphctool.sh"
	else
		einfo "Group not automatically added. Please run phctool as root."
	fi

	python_mod_optimize ${MY_PROGDIR}
}

pkg_postrm() {
	python_mod_cleanup ${MY_PROGDIR}
}
