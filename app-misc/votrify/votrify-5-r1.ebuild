# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit python-single-r1

DESCRIPTION="Tool for community verification of Gentoo elections"
HOMEPAGE="https://github.com/mgorny/votrify/"
SRC_URI="
	https://github.com/mgorny/votrify/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	app-misc/gentoo-elections
"

src_configure() {
	# update default location for election scripts
	sed -i -e "s^os.path.dirname(__file__)^'${EPREFIX}/usr/lib'^" \
		votrify-make-confirmation || die

	python_fix_shebang votrify-{make,verify}-*
}

make_wrappers() {
	local election=${1}

	newbin - "votrify-${election}-make" \
		< <(sed -e "s^@ELECTION@^${election}^" \
			votrify-wrapper-make.bash.in || die)
	newbin - "votrify-${election}-verify" \
		< <(sed -e "s^@ELECTION@^${election}^" \
			votrify-wrapper-verify.bash.in || die)
}

src_install() {
	dobin votrify-{make,verify}-*
	make_wrappers council-201906
	einstalldocs
}

pkg_postinst() {
	elog "In order to interactively create confirmation for Council 2019 election:"
	elog "  votrify-council-201906-make"
	elog
	elog "In order to verify the results for Council 2019 election:"
	elog "  votrify-council-201906-verify"
}
