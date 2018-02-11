# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Static code analysis and dynamic code analysis tools"
HOMEPAGE="https://www.coverity.com"
SRC_URI="amd64? ( cov-analysis-linux64-${PV}.tar.gz )
	x86? ( cov-analysis-linux-${PV}.tar.gz )"

LICENSE="coverity-PLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch mirror bindist"

QA_PREBUILT="opt/coverity/bin/*"

pkg_nofetch() {
	eerror "Please go to https://scan.coverity.com/download"
	use amd64 && eerror "and download Linux64"
	use x86   && eerror "and download Linux32"
	eerror "then put the file in DISTDIR"
	use amd64 && eerror "named as cov-analysis-linux64-${PV}.tar.gz"
	use x86   && eerror "named as cov-analysis-linux-${PV}.tar.gz"
}

src_unpack() {
	default

	use amd64 && mv "${WORKDIR}/cov-analysis-linux64-${PV}" "${S}"
	use x86   && mv "${WORKDIR}/cov-analysis-linux-${PV}" "${S}"
}

src_prepare () {
	default

	# Rename invalid locale files
	mv locale/zh-cn locale/zh-CN || die "Failed to rename locale"

	# Cleanup
	find -type f -name '*.DS_Store' -delete || die
	find -type f -name '*.bak' -delete || die

	rm -rf lib/python* || die

	# Already available in /usr/portage/licenses
	rm -r doc/*/licenses || die
	rm    doc/*/ScanUserAgreementv2016.1.pdf || die
}

src_install () {
	newenvd "${FILESDIR}/${PN}.envd" "99${PN}"

	insinto "/opt/${PN}"
	doins -r config doc dtd lib

	exeinto "/opt/${PN}"
	doexe bin/cov-*
	doexe bin/lib*.so

	insinto /usr/share
	doins -r locale
}

pkg_postinst() {
	elog "Coverity build tool comes pre-configured for gcc, msvc and java."
	elog "For other compiler, run cov-configure as described in"
	elog "https://communities.coverity.com/thread/2726#5328"
	elog
	elog "See also: https://communities.coverity.com/message/4838#4838"
	elog
	elog "You need to run env-update and source /etc/profile in any open shells"
	elog "to get coverity in PATH"
}
