# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="The Gentoo Development Guide"
HOMEPAGE="https://devmanual.gentoo.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/devmanual.git"
else
	SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-macos"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="+offline"

BDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	gnome-base/librsvg
	media-fonts/open-sans"

PATCHES=( "${FILESDIR}"/${PN}-eclasses.patch )

src_compile() {
	emake OFFLINE=$(usex offline 1 0)
}

src_install() {
	emake OFFLINE=$(usex offline 1 0) \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	local DOC_CONTENTS="In order to browse the Gentoo Development Guide in
		offline mode, point your browser to the following url:
		file://${EPREFIX}/usr/share/doc/${PF}/html/index.html"
	if ! has_version app-doc/eclass-manpages; then
		DOC_CONTENTS+="\\n\\nThe offline version of the devmanual does not
			include the documentation for the eclasses. If you need it,
			then emerge app-doc/eclass-manpages."
	fi
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
