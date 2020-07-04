# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-r1

DESCRIPTION="Versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="https://github.com/dagwieers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples wifi"
REQUIRED_USE="wifi? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	wifi? (
		${PYTHON_DEPS}
		net-wireless/python-wifi
	)"
DEPEND=""

PATCHES=( \
	"${FILESDIR}/dstat-${PV}-skip-non-sandbox-tests.patch" \
	"${FILESDIR}/fix-collections-deprecation-warning.patch" \
)

src_prepare() {

	# bug fix: allow delay to be specified
	# backport from: https://github.com/dagwieers/dstat/pull/167/files
	sed -i -e 's; / op\.delay; // op.delay;' "dstat" || die

	default
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	if use examples; then
		dodoc examples/{mstat,read}.py
	fi
	if use doc; then
		dodoc docs/*.html
	fi
}
