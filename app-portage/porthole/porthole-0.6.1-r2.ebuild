# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="xml threads"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="A GTK+-based frontend to Portage"
HOMEPAGE="http://porthole.sourceforge.net"
SRC_URI="mirror://sourceforge/porthole/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="nls"
LANGS="de pl ru vi it fr tr"
for X in $LANGS; do IUSE="${IUSE} linguas_${X}"; done

RDEPEND=">=sys-apps/portage-2.1
	dev-python/pygtk:2
	gnome-base/libglade:2.0
	dev-python/pygtksourceview:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.14 )"

src_prepare() {
	epatch "${FILESDIR}/${P}-masking_status.patch" # bug 307037
	epatch "${FILESDIR}/${P}-missing_import.patch" # bug 323179
}

src_compile(){
	# Compile localizations if necessary
	if use nls ; then
		cd scripts
		./pocompile.sh -emerge ${LINGUAS} || die "pocompile failed"
	fi
}

src_install() {
	distutils_src_install

	dodoc TODO README NEWS AUTHORS

	keepdir /var/log/porthole
	fperms g+w /var/log/porthole
	keepdir /var/db/porthole
	fperms g+w /var/db/porthole

	# nls
	if use nls; then
		# mo directory doesn't exists with nls enabled and unsupported LINGUAS
		[[ -d porthole/i18n/mo ]] && domo porthole/i18n/mo/*
	fi
}

pkg_preinst() {
	chgrp portage "${D}"/var/log/porthole
	chgrp portage "${D}"/var/db/porthole
}

pkg_postinst() {
	einfo
	einfo "Porthole has updated the way that the upgrades are sent to emerge."
	einfo "In this new way the user needs to set any 'Settings' menu emerge options"
	einfo "Porthole automatically adds '--oneshot' for all upgrades selections"
	einfo "Other options recommended are '--noreplace'  along with '--update'"
	einfo "They allow for portage to skip any packages that might have already"
	einfo "been upgraded as a dependency of another previously upgraded package"
	einfo
}
