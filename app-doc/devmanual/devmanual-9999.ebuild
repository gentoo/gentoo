# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="The Gentoo Development Guide"
HOMEPAGE="https://devmanual.gentoo.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/devmanual.git"
else
	SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-macos"
fi

LICENSE="CC-BY-SA-3.0"
SLOT="0"
IUSE="+fallback"

BDEPEND="dev-libs/libxslt
	media-gfx/imagemagick[truetype,svg,png]"

src_prepare() {
	default
	use fallback && eapply "${FILESDIR}"/${PN}-fallback.patch
}

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
	# clean out XML/XSL before installing
	find . \( \
		-iname '*.xml' -o \
		-iname '*.xsl' -o \
		-iname '*.svg' \) -delete || die
	rm -r README.md xsl LICENSE Makefile || die

	local HTML_DOCS=( . )
	einstalldocs

	einfo "Creating symlink from ${PF} to ${PN} for preserving bookmarks"
	dosym ${PF} /usr/share/doc/${PN}

	local DOC_CONTENTS="In order to browse the Gentoo Development Guide in
		offline mode, point your browser to the following url:
		${EPREFIX}/usr/share/doc/devmanual/html/index.html"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version app-doc/eclass-manpages; then
		elog "The offline version of the devmanual does not include the"
		elog "documentation for the eclasses. If you need it, then emerge"
		elog "the following package:"
		elog
		elog "app-doc/eclass-manpages"
		elog
	fi
}
