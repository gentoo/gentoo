# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 user

DESCRIPTION="Processor Hardware Control userland configuration tool"
HOMEPAGE="http://www.linux-phc.org/"
SRC_URI="http://www.linux-phc.org/forum/download/file.php?id=50 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sudo"

DEPEND="${PYTHON_DEPS}
	dev-python/egg-python[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sudo? ( app-admin/sudo )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PV%.*}-${PV##*.}/${PN}"

pkg_setup() {
	MY_PROGDIR="/usr/share/${PN}"
	if use sudo ; then
		MY_GROUPNAME="phcusers"
		enewgroup ${MY_GROUPNAME}
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}"/${P}_all_paths_tray.patch
	if use sudo ; then
		eapply "${FILESDIR}"/${P}_all_paths_tool_sudo.patch
	else
		eapply "${FILESDIR}"/${P}_all_paths_tool_no_sudo.patch
	fi
	eapply "${FILESDIR}"/${P}_kernel_2.6.36.patch
	eapply "${FILESDIR}"/${P}_gui_kernel_2.6.38.patch
	eapply_user
	find . -name "*.pyc" -delete || die
	python_fix_shebang .
}

src_install() {
	newbin phctool.sh phctool
	newbin phctray.sh phctray

	exeinto ${MY_PROGDIR}
	doexe phc{tool,tray}.py subphctool.sh
	python_moduleinto ${MY_PROGDIR}
	python_domodule inc

	if use sudo ; then
		fowners -R ":${MY_GROUPNAME}" "${MY_PROGDIR}"
		fperms g+rX "${MY_PROGDIR}"
		dodir /etc/sudoers.d
		echo "#%${MY_GROUPNAME} ALL=(root) NOPASSWD:${MY_PROGDIR}/subphctool.sh" \
			> "${ED}"/etc/sudoers.d/${PN} || die
		fperms a-w,o-r /etc/sudoers.d/${PN}
	fi

	dodoc CHANGELOG
	if use doc; then
		docinto html
		dodoc -r doc/docfiles doc/index.htm
	fi
}

pkg_postinst() {
	if use sudo; then
		einfo "You have to add a line to /etc/sudoers to get access to"
		einfo "/sys/devices/system/cpu/cpu1/cpufreq/phc_controls from the phctool/phctray"
		einfo "Please check and uncomment the content of /etc/sudoers.d/${PN}"
	else
		einfo "Group not automatically added. Please run phctool as root."
	fi
}
