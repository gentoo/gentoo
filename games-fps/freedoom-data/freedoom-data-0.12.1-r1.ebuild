# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit prefix python-any-r1 xdg

DESCRIPTION="Game resources for Freedoom: Phase 1+2"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/archive/v${PV}.tar.gz -> freedoom-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP},zlib]')
	app-text/asciidoc
	games-util/deutex[png]"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.1-Python-PIL-10.0.0-support.patch
)

S="${WORKDIR}/freedoom-${PV}"

DOOMWADPATH=share/doom

python_check_deps() {
	has_version -b "dev-python/pillow[${PYTHON_USEDEP},zlib]"
}

src_prepare() {
	xdg_src_prepare

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
		waddir="${DOOMWADPATH}/"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Freedoom WAD files installed into ${EPREFIX}/usr/${DOOMWADPATH} directory."
}
