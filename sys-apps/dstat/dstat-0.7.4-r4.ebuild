# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-r1

DESCRIPTION="Versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="https://github.com/dagwieers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~mips ppc ppc64 ~sparc x86"
IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/dstat-${PV}-skip-non-sandbox-tests.patch"
	"${FILESDIR}/fix-collections-deprecation-warning.patch"
	"${FILESDIR}/dstat-0.7.4-fix-csv-output.patch"
	"${FILESDIR}/dstat-${PV}-fix-backslash-in-regex.patch"
	"${FILESDIR}/dstat-${PV}-use-importlib.patch"
)

src_prepare() {
	# bug fix: allow delay to be specified
	# backport from: https://github.com/dagwieers/dstat/pull/167/files
	sed -e 's; / op\.delay; // op.delay;' -i "dstat" || die

	default
}

src_test() {
	python_foreach_impl emake test
}

src_install() {
	python_foreach_impl python_doscript dstat

	insinto /usr/share/dstat
	newins dstat dstat.py
	doins plugins/dstat_*.py

	doman docs/dstat.1

	einstalldocs

	if use examples; then
		dodoc examples/{mstat,read}.py
	fi
	if use doc; then
		dodoc docs/*.html
	fi
}
