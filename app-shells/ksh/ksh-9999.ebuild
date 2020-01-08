# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/att/ast"
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
	MY_PV="${PV/_/-}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/att/ast/releases/download/${MY_PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="The Original Korn Shell, 1993 revision (ksh93)"
HOMEPAGE="https://github.com/att/ast"

LICENSE="CPL-1.0 EPL-1.0"
SLOT="0"

RDEPEND="!app-shells/pdksh"

src_test() {
	# https://bugs.gentoo.org/702570
	addwrite /proc/self
	local cmd=(
		meson test
		-C "${BUILD_DIR}"
		--num-processes "$(makeopts_jobs ${NINJAOPTS:-${MAKEOPTS}})"
	)
	echo "${cmd[@]}" >&2
	# https://github.com/att/ast/issues/1392
	env -u T "${cmd[@]}" || die
}

src_install() {
	meson_src_install
	dodir /bin
	mv "${ED}/usr/bin/ksh" "${ED}/bin/ksh" || die
}
