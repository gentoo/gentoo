# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/logtalk/logtalk-2.42.2.ebuild,v 1.2 2014/08/10 20:29:05 slyfox Exp $

inherit eutils versionator fdo-mime

DESCRIPTION="Open source object-oriented logic programming language"
HOMEPAGE="http://logtalk.org"
MY_PV="lgt$(delete_all_version_separators)"
SRC_URI="http://logtalk.org/files/${MY_PV}.tar.bz2"
LICENSE="Artistic-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnupl qupl swipl xsbpl yappl xslt fop"

DEPEND=""
RDEPEND="
	gnupl? ( dev-lang/gprolog )
	qupl? ( !amd64? ( dev-lang/qu-prolog ) )
	swipl? ( dev-lang/swi-prolog )
	xsbpl? ( x86? ( dev-lang/xsb ) )
	yappl? ( dev-lang/yap )
	xslt? ( dev-libs/libxslt )
	fop? ( dev-java/fop )
	${DEPEND}"

S="${WORKDIR}/${MY_PV}"

src_install() {
	# Look at scripts/install.sh for upstream installation process.
	# Install logtalk base
	mv scripts/logtalk_user_setup.sh integration/
	mkdir -p "${D}/usr/share/${P}"
	cp -r compiler configs contributions VERSION.txt \
		integration library wenv xml libpaths \
		examples settings.lgt "${D}/usr/share/${P}" \
		|| die "Failed to install files"

	# Install mime file, the database will be updated later
	insinto /usr/share/mime/packages
	doins scripts/freedesktop/logtalk.xml

	# Install documentation
	dodoc BIBLIOGRAPHY.bib CUSTOMIZE.txt INSTALL.txt \
		LICENSE.txt QUICK_START.txt README.txt \
		RELEASE_NOTES.txt UPGRADING.txt VERSION.txt
	dohtml -r manuals/* || die "Failed to install html manual"

	rm -f man/man1/logtalk_backend_select.1
	rm -f man/man1/logtalk_version_select.1
	doman man/man1/*.1 || die "Failed to install man pages"

	# Integration symlinks
	dosym /usr/share/${P}/integration/logtalk_user_setup.sh \
		/usr/bin/logtalk_user_setup
	use gnupl && dosym /usr/share/${P}/integration/gplgt.sh \
		/usr/bin/gplgt
	use qupl && ! use amd64 && dosym /usr/share/${P}/integration/qplgt.sh \
		/usr/bin/qplgt
	use swipl && dosym /usr/share/${P}/integration/swilgt.sh \
		/usr/bin/swilgt
	use xsbpl && use x86 && dosym /usr/share/${P}/integration/xsblgt.sh \
		/usr/bin/xsblgt
	use yappl && dosym /usr/share/${P}/integration/yaplgt.sh \
		/usr/bin/yaplgt

	dosym /usr/share/${P}/xml/lgt2xml.sh /usr/bin/lgt2xml
	use xslt && dosym /usr/share/${P}/xml/lgt2html.sh /usr/bin/lgt2html
	use xslt && dosym /usr/share/${P}/xml/lgt2txt.sh /usr/bin/lgt2txt
	use fop  && dosym /usr/share/${P}/xml/lgt2pdf.sh /usr/bin/lgt2pdf

	# Install environment files
	echo "LOGTALKHOME=/usr/share/${P}" > 99logtalk
	doenvd 99logtalk
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	ewarn "Before running logtalk, users should execute"
	ewarn "logtalk_user_setup *once*."
	ewarn "To start logtalk use one of the following:"
	use gnupl && ewarn "GNU Prolog: /usr/bin/gplgt"
	use qupl && ! use amd64 && ewarn "Qu Prolog: /usr/bin/qplgt"
	use swipl && ewarn "SWI Prolog: /usr/bin/swilgt"
	use xsbpl && use x86 && ewarn "XSB: /usr/bin/xsblgt"
	use yappl && ewarn "YAP: /usr/bin/yaplgt"
	ewarn ""

	ewarn "The environment has been set up to make the above"
	ewarn "integration scripts find files automatically for logtalk."
	ewarn "Please run 'etc-update && source /etc/profile' to update"
	ewarn "the environment now, otherwise it will be updated at next"
	ewarn "login."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
