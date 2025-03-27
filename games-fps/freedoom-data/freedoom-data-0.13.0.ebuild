# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit prefix python-any-r1 xdg

DESCRIPTION="Game resources for Freedoom: Phase 1+2"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/archive/v${PV}.tar.gz -> freedoom-${PV}.tar.gz"
S="${WORKDIR}/freedoom-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

BDEPEND="
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP},zlib]')
	app-text/asciidoc
	dev-util/source-highlight
	games-util/deutex[png]
"

DOOMWADPATH="share/doom"

python_check_deps() {
	python_has_version -b "dev-python/pillow[${PYTHON_USEDEP},zlib]"
}

src_prepare() {
	default
	hprefixify dist/freedoom
}

src_compile() {
	emake wads/freedoom{1,2}.wad \
		freedoom{1,2}.6 \
		{NEWS,README}.html
}

src_install() {
	emake install-freedoom \
		prefix="${ED}/usr/" \
		bindir="bin/" \
		docdir="share/doc/${PF}" \
		mandir="share/man/" \
		waddir="${DOOMWADPATH}/" \
		MANUAL_PDF_FILES=
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Freedoom WAD files installed into ${EPREFIX}/usr/${DOOMWADPATH} directory."
}
