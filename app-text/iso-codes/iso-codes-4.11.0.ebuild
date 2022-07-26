# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PLOCALES="ab ace ach af ak am an ar as ast ay az ba bar be bg bi bn bn_BD bn_IN br bs byn ca ce ch chr ckb crh cs csb cv cy da de dv dz ee el en eo es et eu fa ff fi fil fo fr frp fur fy ga gez gl gn gu gv ha haw he hi hr ht hu hy ia id io is it iu ja jam ka kab ki kk kl km kmr kn ko kok kv kw ky lo lt lv mai mhr mi mk ml mn mo mr ms mt my na nah nb nb_NO ne nl nn nso nv oc or pa pap pi pl ps pt pt_BR ro ru rw sc sd si sk sl so son sq sr sr@latin sv sw ta te tg th ti tig tk tl tr tt tt@iqtelif tzm ug uk ur uz ve vi wa wal wo xh yo zh_CN zh_HK zh_Hans zh_Hant zh_TW zu"

inherit python-any-r1

DESCRIPTION="ISO language, territory, currency, script codes and their translations"
HOMEPAGE="https://salsa.debian.org/iso-codes-team/iso-codes"
SRC_URI="https://salsa.debian.org/${PN}-team/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext
"
S="${WORKDIR}/${PN}-v${PV}"

# This ebuild does not install any binaries.
RESTRICT="binchecks strip"

DOCS=( CHANGELOG.md README.md )

# plocale_find_changes doesn't support multiple directories,
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
			if has ${loc%.po} ${LINGUAS-${loc%.po}}; then
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
