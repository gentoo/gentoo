# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES='fr'

inherit flag-o-matic eutils toolchain-funcs l10n versionator

MAJ_PV=$(get_version_component_range 1)
MIN_PV=$(get_version_component_range 2)
REL_PV=$(get_version_component_range 3)
MY_PV="${REL_PV^^}.${MAJ_PV}.${MIN_PV}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Hardware Lister"
HOMEPAGE="https://ezix.org/project/wiki/HardwareLiSter"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="gtk sqlite static"

REQUIRED_USE="static? ( !gtk )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	sqlite? ( virtual/pkgconfig )"
RDEPEND="${RDEPEND}
	sys-apps/hwids"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-02.18b-gentoo.patch
		# "${FILESDIR}"/${PN}-02.17b-musl.patch
	)
	default

	local loc_dir='src/po' loc_pre='' loc_post='.po'
	l10n_find_plocales_changes "${loc_dir}" "${loc_pre}" "${loc_post}"
	rm_loc() {
		rm -vf "${loc_dir}/${loc_pre}${1}${loc_post}" || die
		sed -r -e "s|(LANGUAGES *=.*) ${1}(.*)|\1 \2|" \
			-i -- "${loc_dir}/Makefile" || die
	}
	l10n_for_each_disabled_locale_do rm_loc

	# disable calling home for updates
	sed -e 's|= *checkupdates();|= NULL;|' \
		-i -- src/lshw.cc src/gui/callbacks.c || die

	# set proper version
	sed -e -e "s|(static char \\* result = )NULL|\1\"${MY_P}-gentoo\"|" \
		-i -- src/core/version.cc || die

	find -name Makefile | xargs sed -e "s|VERSION *.?=.*|VERSION = ${MY_PV}|" -i --
	assert
}

src_compile() {
	use static && append-ldflags -static

	local emake_args=(
		SQLITE=$(usex sqlite 1 0)
		all
		$(usex gtk 'gui' '')
	)
	emake "${emake_args[@]}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
		install $(usex gtk 'install-gui' '')

	newicon -s scalable src/gui/artwork/logo.svg ${PN}.svg

	local DOCS=( README.md docs/* )
	einstalldocs

	make_desktop_entry \
		"${EPREFIX}"/usr/sbin/gtk-lshw \
		"${DESCRIPTION}"
}
