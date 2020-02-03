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
	KEYWORDS="~amd64 ~arm ~hppa ~m68k ~mips ~s390 ~sh ~sparc ~x86 ~x64-macos"
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
	emake build OFFLINE=$(usex offline 1 0)
	use offline || emake documents.js
}

src_install() {
	# clean out XML/XSL before installing
	find . \( \
		-iname '*.xml' -o \
		-iname '*.dtd' -o \
		-iname '*.xsl' -o \
		-iname '*.svg' \) -delete || die
	rm -r bin xsl .git* LICENSE Makefile README.md || die

	local HTML_DOCS=( . )
	einstalldocs

	local DOC_CONTENTS="In order to browse the Gentoo Development Guide in
		offline mode, point your browser to the following url:
		file://${EPREFIX}/usr/share/doc/${PF}/html/index.html"
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
	fi
}
