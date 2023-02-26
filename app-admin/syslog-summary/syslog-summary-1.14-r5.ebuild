# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1

DESCRIPTION="Summarizes the contents of a syslog log file"
HOMEPAGE="https://github.com/dpaleino/syslog-summary"
SRC_URI="https://github.com/downloads/dpaleino/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

PATCHES=( \
	"${FILESDIR}/${P}-fix-ignore-code.patch" \
	"${FILESDIR}/${P}-remove-file-magic.patch" \
	"${FILESDIR}/${P}-py3.patch" \
	)

src_prepare() {
	python_fix_shebang -f syslog-summary

	# Sadly, the makefile is useless for us.
	rm Makefile || die

	default
}

src_install() {
	dobin syslog-summary
	einstalldocs
	doman syslog-summary.1

	insinto /etc/syslog-summary
	doins ignore.rules
}
