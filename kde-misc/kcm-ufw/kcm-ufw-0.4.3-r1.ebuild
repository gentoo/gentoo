# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcm-ufw/kcm-ufw-0.4.3-r1.ebuild,v 1.5 2015/06/04 18:57:32 kensington Exp $

EAPI=5

KDE_DOC_DIRS="docs/%lingua"
KDE_HANDBOOK="optional"
KDE_LINGUAS="es fr lt"
PYTHON_COMPAT=( python2_7 )
inherit python-r1 kde4-base multilib

MY_P="${P/-/_}"

DESCRIPTION="KCM module to control the Uncomplicated Firewall"
HOMEPAGE="http://kde-apps.org/content/show.php?content=137789"
SRC_URI="http://craigd.wikispaces.com/file/view/${MY_P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=net-firewall/ufw-0.31
	sys-auth/polkit-kde-agent
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kcmshell)
"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-linguas.patch" )

src_install() {
	kde4-base_src_install
	python_replicate_script "${D}"/usr/$(get_libdir)/kde4/libexec/kcm_ufw_helper.py
}
