# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="Flexible backup script using perl"
HOMEPAGE="http://flexbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="app-arch/mt-st"
DEPEND="${RDEPEND}"

DOCS="CHANGES CREDITS README TODO"
HTML_DOCS="faq.html"

src_prepare() {
	# Patch from upstream adds optional lzma compression mode.
	eapply -p0 "${FILESDIR}"/${P}-lzma.patch

	# Fix bug #116510: cannot back up remote machines after patch CAN-2005-2965
	eapply "${FILESDIR}"/${P}-secure-tempfile.patch

	# Fix bug #96334: incorrectly determines bash 3.x to be bash 1.x
	eapply -p0 "${FILESDIR}"/${P}-bash.patch

	# Fix bug #171205: specifies wrong command line option for mbuffer / other small enhancements
	eapply "${FILESDIR}"/${P}-mbuffer-switch.patch

	# Fix bug #173672: remote host buffer test is broken
	eapply "${FILESDIR}"/${P}-remote-bufftest.patch

	# Fix bug #178126: subtle subtree pruning issue / other small issues
	eapply "${FILESDIR}"/${P}-prune.patch

	# Fix bug #184560: fails to back up targets with spaces in their names in some modes
	eapply -p0 "${FILESDIR}"/${P}-spaces-in-filenames.patch

	# Fix bug #190357: fails on very large files with afio back end
	eapply -p0 "${FILESDIR}"/${P}-afio-large-files.patch

	# Fix bug #235416: prevent normal status message during conf file read from going to stderr
	eapply -p0 "${FILESDIR}"/${P}-quieten.patch

	# Fix bug #331673: perl 5.12 deprecation warnings.
	eapply -p0 "${FILESDIR}"/${P}-perl-5.12-deprecation-warning.patch

	# Fix bug #495232: perl 5.16 deprecation warnings.
	eapply -p0 "${FILESDIR}"/${P}-perl-5.16-deprecation-warning.patch

	# Fix bug #601368: app-backup/flexbackup breaks with >=app-arch/tar-1.29 when making tar-based backups
	eapply "${FILESDIR}"/${P}-tar-1.29.patch

	eapply_user

	sed -i \
		-e '/^\$type = /s:afio:tar:' \
		-e "/^\$buffer = /s:'buffer':'false':" \
		flexbackup.conf \
		|| die "Failed to set modified configuration defaults."

	MY_PV=$(replace_all_version_separators '_')
	sed -i \
		-e "/^[[:blank:]]*my \$ver = /s:${MY_PV}:&-${PR}:" \
		flexbackup \
		|| die "Failed to apply ebuild revision to internal version string."
}

src_install() {
	dodir /etc /usr/bin /usr/share/man/man{1,5}
	emake install \
		PREFIX="${D}"/usr \
		CONFFILE="${D}"/etc/flexbackup.conf

	einstalldocs
}

pkg_postinst() {
	elog "Please edit your /etc/flexbackup.conf file to suit your"
	elog "needs.  If you are using devfs, the tape device should"
	elog "be set to /dev/tapes/tape0/mtn.  If you need to use any"
	elog "archiver other than tar, please emerge it separately."
}
