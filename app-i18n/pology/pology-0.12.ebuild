# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/pology/pology-0.12.ebuild,v 1.1 2015/03/04 11:13:49 kensington Exp $

EAPI=5

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/l10n-support/pology"
PYTHON_COMPAT=( python2_7 )

[[ ${PV} == 9999 ]] && VCS_ECLASS="subversion"

inherit python-single-r1 cmake-utils bash-completion-r1 ${VCS_ECLASS}
unset VCS_ECLASS

DESCRIPTION="A framework for custom processing of PO files"
HOMEPAGE="http://pology.nedohodnik.net"
[[ ${PV} == 9999 ]] || SRC_URI="http://pology.nedohodnik.net//release/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libxslt
	dev-libs/libxml2
	dev-python/dbus-python[${PYTHON_USEDEP}]
	sys-devel/gettext
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.5
	dev-python/epydoc[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Magic on python parsing makes it impossible to make it parallel safe
MAKEOPTS+=" -j1"

src_prepare() {
	python_fix_shebang .
}

src_install() {
	cmake-utils_src_install

	dosym ../../../pology/syntax/kate/synder.xml /usr/share/apps/katepart/syntax/synder.xml

	newbashcomp "${ED}"/usr/share/pology/completion/bash/pology posieve
	bashcomp_alias {posieve,poediff}{,.py}

	einfo "You should also consider following packages to install:"
	einfo "    app-text/aspell"
	einfo "    app-text/hunspell"
	einfo "    dev-vcs/git"
	einfo "    dev-vcs/subversion"
	einfo "    sci-misc/apertium"
}
