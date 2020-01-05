# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1

DESCRIPTION="Future-aware personal finances management"
HOMEPAGE="https://hardcoded.net/moneyguru"
SRC_URI="https://download.hardcoded.net/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets,printsupport]
	dev-qt/qttranslations"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-util/cunit
	)"

_emake() {
	emake CFLAGS="\$(DEFAULT_CFLAGS) ${CFLAGS}" \
		SHEBANG="${PYTHON}" \
		DESTDIR="${ED}" \
		PREFIX="${EPREFIX}/usr" \
		"$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake install
}

src_test() {
	emake -C ccore CFLAGS="\$(DEFAULT_CFLAGS) ${CFLAGS}" tests
	pytest -vv core || die "Tests failed with ${EPYTHON}"
}
