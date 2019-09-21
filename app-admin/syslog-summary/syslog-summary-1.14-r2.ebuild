# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Summarizes the contents of a syslog log file"
HOMEPAGE="https://github.com/dpaleino/syslog-summary"
SRC_URI="https://github.com/downloads/dpaleino/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

src_prepare() {
	python_fix_shebang -f syslog-summary

	sed -i -e 's:python-magic:sys-apps/file[python]:' "syslog-summary" || die

	# Sadly, the makefile is useless for us.
	rm Makefile || die

	eapply_user
}

src_install() {
	dobin syslog-summary
	einstalldocs
	doman syslog-summary.1

	insinto /etc/syslog-summary
	doins ignore.rules
}

pkg_postinst() {
	elog "install sys-apps/file[python] to enable processing"
	elog "of gzip compressed logfiles"
}
