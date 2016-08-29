# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )
PLOCALES="af am ar as ast az be bg bn bn_IN br bs byn ca crh cs cy da de dz el en eo es et eu fa fi fo fr ga gez gl gu haw he hi hr hu hy ia id is it ja ka kk km kn ko kok ku lt lv mi mk ml mn mr ms mt nb ne nl nn nso oc or pa pl ps pt pt_BR ro ru rw si sk sl so sq sr sr@latin sv sw ta te th ti tig tk tl tr tt tt@iqtelif ug uk ve vi wa wal wo xh zh_CN zh_HK zh_TW zu"

inherit eutils l10n python-any-r1

DESCRIPTION="ISO language, territory, currency, script codes and their translations"
HOMEPAGE="http://pkg-isocodes.alioth.debian.org/"
SRC_URI="http://pkg-isocodes.alioth.debian.org/downloads/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${PYTHON_DEPS}
	app-arch/xz-utils
	sys-devel/gettext
"

# This ebuild does not install any binaries.
RESTRICT="binchecks strip"

# l10n_find_plocales_changes doesn't support multiple directories,
# so need to do the update scan ourselves.
check_existing_locales() {
	local std loc all_locales=()

	ebegin "Looking for new locales"
	for std in "${all_stds[@]}"; do
		pushd "${std}" >/dev/null || die
		for loc in *.po; do
			all_locales+=( "${loc%.po}" )
		done
		popd >/dev/null
	done

	all_locales=$(echo $(printf '%s\n' "${all_locales[@]}" | LC_COLLATE=C sort -u))
	if [[ ${PLOCALES} != "${all_locales}" ]]; then
		eend 1
		eerror "There are changes in locales! This ebuild should be updated to:"
		eerror "PLOCALES=\"${all_locales}\""
		die "Update PLOCALES in the ebuild"
	else
		eend 0
	fi
}

src_prepare() {
	default

	local std loc mylinguas
	local all_stds=( iso_15924 iso_3166-{1,2,3} iso_4217 iso_639-{2,3,5} )

	check_existing_locales

	# Modify the Makefiles so they only install requested locales.
	for std in "${all_stds[@]}"; do
		einfo "Preparing ${std} ..."
		pushd "${std}" >/dev/null || die
		mylinguas=()
		for loc in *.po; do
			if use "linguas_${loc%.po}"; then
				mylinguas+=( "${loc}" )
			fi
		done

		sed \
			-e "/^pofiles =/s:=.*:= ${mylinguas[*]}:" \
			-e "/^mofiles =/s:=.*:= ${mylinguas[*]/%.po/.mo}:" \
			-i Makefile.am Makefile.in || die "sed in ${std} folder failed"
		popd >/dev/null
	done
}
