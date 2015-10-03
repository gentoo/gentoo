# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="af am ar as ast az be bg bn bn_IN br bs byn ca crh cs cy da de dz el en eo es et eu fa fi fo fr ga gez gl gu haw he hi hr hu hy ia id is it ja ka kk km kn ko kok ku lt lv mi mk ml mn mr ms mt nb ne nl nn nso oc or pa pl ps pt pt_BR ro ru rw si sk sl so sq sr sr@latin sv sw ta te th ti tig tk tl tr tt tt@iqtelif ug uk ve vi wa wal wo xh zh_CN zh_HK zh_TW zu"

inherit eutils l10n

DESCRIPTION="ISO language, territory, currency, script codes and their translations"
HOMEPAGE="http://pkg-isocodes.alioth.debian.org/"
SRC_URI="http://pkg-isocodes.alioth.debian.org/downloads/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="
	app-arch/xz-utils
	sys-devel/gettext
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	local norm loc all_locales mylinguas
	local all_norms="iso_15924 iso_3166 iso_3166_2 iso_4217 iso_639 iso_639_3 iso_639_5"

	# l10n_find_plocales_changes doesn't support multiple directories
	einfo "Looking for new locales ..."
	for norm in ${all_norms}; do
		pushd "${norm}" > /dev/null || die
		for loc in *.po; do
			all_locales+="${loc%.po} "
		done
		popd > /dev/null
	done

	all_locales=$(echo "${all_locales}" | sed 's/ /\n/g' | sort | uniq)
	all_locales=${all_locales//[[:space:]]/ }
	all_locales=${all_locales#[[:space:]]}
	all_locales=${all_locales%[[:space:]]}
	if [[ ${PLOCALES} != ${all_locales} ]]; then
		einfo "There are changes in locales! This ebuild should be updated to:"
		einfo "PLOCALES=\"${all_locales}\""
	else
		einfo "Done"
	fi

	for norm in ${all_norms}; do
		einfo "Preparing ${norm} ..."
		pushd "${norm}" > /dev/null || die
		mylinguas=
		for loc in *.po; do
			if use "linguas_"${loc%.po}; then
				mylinguas+="${loc} "
			fi
		done

		sed -e "s:pofiles =.*:pofiles = ${mylinguas} ${NULL}:" \
			-e "s:mofiles =.*:mofiles = ${mylinguas//.po/.mo} ${NULL}:" \
			-i Makefile.am Makefile.in || die "sed in ${norm} folder failed"
		popd > /dev/null
	done
}
