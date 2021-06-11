# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit prefix python-any-r1 xdg

DESCRIPTION="Game resources for FreeDM"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/archive/v${PV}.tar.gz -> freedoom-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP}]')
	app-text/asciidoc
	games-util/deutex"

S="${WORKDIR}/freedoom-${PV}"

DOOMWADPATH=share/doom

python_check_deps() {
	has_version -b "dev-python/pillow[${PYTHON_USEDEP}]"
}

src_prepare() {
	xdg_src_prepare
	eapply_user

	hprefixify dist/freedoom
}

src_compile() {
	emake wads/freedm.wad \
		freedm.6 \
		{NEWS,README}.html
}

src_install() {
	emake install-freedm \
		prefix="${ED}/usr/" \
		bindir="bin/" \
		docdir="share/doc/${P}" \
		mandir="share/man/" \
		waddir="${DOOMWADPATH}/"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "FreeDM WAD file installed into ${EPREFIX}/usr/${DOOMWADPATH} directory."
}
