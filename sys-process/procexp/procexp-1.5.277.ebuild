# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils gnome2-utils multilib python-single-r1 rpm versionator

MY_P="process_explorer-$(replace_version_separator 2 '-')"

DESCRIPTION="Graphical process explorer"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/procexp/index.php?title=Main_Page"
SRC_URI="mirror://sourceforge/project/procexp/${MY_P}.noarch.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pyqwt[${PYTHON_USEDEP}]
	sys-auth/polkit"

S="${WORKDIR}/opt/${MY_P}/${PN}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# No build system provided by upstream
# https://sourceforge.net/tracker/?func=detail&aid=3573774&group_id=309156&atid=1301952

src_prepare() {
	# Removing unnecessary svn cruft
	esvn_clean

	rm make_rpm.py process_explorer.spec ${PN}.desktop ${PN}.sh || die 'remove unneeded files failed'

	epatch_user

	python_fix_shebang .
}

src_install() {
	newicon -s 48 icon.png ${PN}.png
	rm icon.png || die

	insinto "/usr/share/polkit-1/actions"
	doins com.procexp.pkexec.policy
	rm com.procexp.pkexec.policy || die

	insinto "/usr/$(get_libdir)/${PN}"
	doins -r *
	fperms +x "/usr/$(get_libdir)/${PN}/procexp.py"
	fperms +x "/usr/$(get_libdir)/${PN}/rootproxy/procroot.py"

	dosym "/usr/$(get_libdir)/${PN}/procexp.py" /usr/bin/procexp
	make_desktop_entry ${PN} "Linux Process Explorer" ${PN} "System;Utility;"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
