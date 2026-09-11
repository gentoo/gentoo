# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Easy to use GUI & CLI alternative for etc-update"
HOMEPAGE="https://github.com/rich0/cfg-update"
SRC_URI="https://github.com/rich0/cfg-update/archive/${PV}.tar.gz -> ${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test X"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-shells/bash
		sys-apps/diffutils
	)
"
RDEPEND="
	dev-perl/TermReadKey
	X? (
		>=x11-misc/sux-1.0
		x11-apps/xhost
	)
"

pkg_prerm() {
	if [[ -z ${ROOT} ]]
	then
		ebegin "Disabling portage hook"
		cfg-update --ebuild --disable-portage-hook
		eend $?
		ebegin "Disabling paludis hook"
		cfg-update --ebuild --disable-paludis-hook
		eend $?
	fi
}

pkg_postrm() {
	echo
	ewarn "If you want to permanently remove cfg-update from your system"
	ewarn "you should remove the index file /var/lib/cfg-update/checksum.index"
	echo
}

src_test() {
	einfo "Running cfg-update integration test harness"
	"${S}"/test/run-tests.sh --full || die "Integration tests failed"
}

src_install() {
	dobin cfg-update
	insinto /usr/lib/cfg-update
	doins cfg-update cfg-update_indexing
	dodoc ChangeLog
	doman *.8
	insinto /etc
	doins cfg-update.conf
	keepdir /var/lib/cfg-update
}

pkg_postinst() {
	echo
	einfo "If this is a first time install, please check the configuration"
	einfo "in /etc/cfg-update.conf before using cfg-update:"
	echo
	einfo "If your system does not have an X-server installed you need to"
	einfo "change the MERGE_TOOL to sdiff, imediff, or vimdiff."
	einfo "If you have X installed, set MERGE_TOOL to your favorite GUI tool:"
	einfo "meld (default), kdiff3, xxdiff, gvimdiff, tkdiff, kompare"
	echo
	einfo "TIP: to maximize the chances of future automatic updates, run:"
	einfo "cfg-update --optimize-backups"
	echo
}
