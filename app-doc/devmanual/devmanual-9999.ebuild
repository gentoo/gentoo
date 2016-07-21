# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 readme.gentoo

DESCRIPTION="The Gentoo Development Guide"
HOMEPAGE="https://devmanual.gentoo.org/"
EGIT_REPO_URI="git://anongit.gentoo.org/proj/devmanual.git"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libxslt
	media-gfx/imagemagick[truetype,svg,png]"

DOC_CONTENTS="In order to browse the Gentoo Development Guide in
	offline mode, point your browser to the following url:
	/usr/share/doc/devmanual/html/index.html"

src_compile() {
	# Imagemagick uses inkscape (if present) to delegate
	# svg conversions.
	# Inkscape uses g_get_user_config_dir () which in turn
	# uses XDG_CONFIG_HOME to get the config directory for this
	# user. See bug 463380
	export XDG_CONFIG_HOME="${T}/inkscape_home"
	emake
}

src_install() {
	dohtml -r *
	einfo "Creating symlink from ${P} to ${PN} for preserving bookmarks"
	dosym /usr/share/doc/${P} /usr/share/doc/${PN}
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version app-portage/eclass-manpages; then
		elog "The offline version of the devmanual does not include the"
		elog "documentation for the eclasses. If you need it, then emerge"
		elog "the following package:"
		elog
		elog "app-portage/eclass-manpages"
		elog
	fi
}
