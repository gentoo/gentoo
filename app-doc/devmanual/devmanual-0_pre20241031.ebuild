# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
inherit python-any-r1 readme.gentoo-r1

DESCRIPTION="The Gentoo Development Guide"
HOMEPAGE="https://devmanual.gentoo.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/devmanual.git"
else
	# "make dist" in devmanual repo
	SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="+offline test"
RESTRICT="!test? ( test )"

BDEPEND=">=dev-libs/libxml2-2.9.12
	dev-libs/libxslt
	gnome-base/librsvg
	media-fonts/open-sans
	${PYTHON_DEPS}
	test? ( >=app-text/htmltidy-5.8.0 )"

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
