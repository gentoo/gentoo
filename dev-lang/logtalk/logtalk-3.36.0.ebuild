# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils xdg-utils

DESCRIPTION="Open source object-oriented logic programming language"
HOMEPAGE="https://logtalk.org"
SRC_URI="https://logtalk.org/files/${P}.tar.bz2"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="fop xslt"

DEPEND=""
RDEPEND="${DEPEND}
	xslt? ( dev-libs/libxslt )
	fop? ( dev-java/fop )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-portage.patch

	eapply_user
}

src_install() {
	# Look at scripts/install.sh for upstream installation process.
	# Install logtalk base
	mv scripts/logtalk_user_setup.sh integration/
	mkdir -p "${D}/usr/share/${P}"
	cp -r adapters coding contributions core docs examples integration \
		library manuals paths scratch tests tools VERSION.txt \
		loader-sample.lgt settings-sample.lgt tester-sample.lgt \
		tests-sample.lgt \
		"${D}/usr/share/${P}" \
		|| die "Failed to install files"

	# Install mime file, the database will be updated later
	insinto /usr/share/mime/packages
	doins scripts/freedesktop/logtalk.xml

	# Install documentation
	dodoc ACKNOWLEDGMENTS.md BIBLIOGRAPHY.bib CONTRIBUTING.md \
		CUSTOMIZE.md INSTALL.md LICENSE.txt QUICK_START.md \
		README.md RELEASE_NOTES.md UPGRADING.md VERSION.txt

	rm -f man/man1/logtalk_backend_select.1
	rm -f man/man1/logtalk_version_select.1
	doman man/man1/*.1

	# Integration symlinks
	dosym ../share/${P}/integration/logtalk_user_setup.sh \
		/usr/bin/logtalk_user_setup
	dosym ../share/${P}/integration/bplgt.sh \
		/usr/bin/bplgt
	dosym ../share/${P}/integration/cxlgt.sh \
		/usr/bin/cxlgt
	dosym ../share/${P}/integration/eclipselgt.sh \
		/usr/bin/eclipselgt
	dosym ../share/${P}/integration/gplgt.sh \
		/usr/bin/gplgt
	dosym ../share/${P}/integration/jiplgt.sh \
		/usr/bin/jiplgt
	dosym ../share/${P}/integration/lplgt.sh \
		/usr/bin/lplgt
	dosym ../share/${P}/integration/qplgt.sh \
		/usr/bin/qplgt
	dosym ../share/${P}/integration/quintuslgt.sh \
		/usr/bin/quintuslgt
	dosym ../share/${P}/integration/sicstuslgt.sh \
		/usr/bin/sicstuslgt
	dosym ../share/${P}/integration/swilgt.sh \
		/usr/bin/swilgt
	dosym ../share/${P}/integration/xsblgt.sh \
		/usr/bin/xsblgt
	dosym ../share/${P}/integration/xsbmtlgt.sh \
		/usr/bin/xsbmtlgt
	dosym ../share/${P}/integration/yaplgt.sh \
		/usr/bin/yaplgt

	dosym ../share/${P}/tools/lgtdoc/xml/lgt2xml.sh \
		/usr/bin/lgt2xml
	use xslt && dosym ../share/${P}/tools/lgtdoc/xml/lgt2html.sh \
		/usr/bin/lgt2html
	use xslt && dosym ../share/${P}/tools/lgtdoc/xml/lgt2txt.sh \
		/usr/bin/lgt2txt
	use xslt && dosym ../share/${P}/tools/lgtdoc/xml/lgt2md.sh \
		/usr/bin/lgt2md
	use fop  && dosym ../share/${P}/tools/lgtdoc/xml/lgt2pdf.sh \
		/usr/bin/lgt2pdf

	# Install environment files
	echo "LOGTALKHOME=/usr/share/${P}" > 99logtalk
	doenvd 99logtalk
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	ewarn "The following integration scripts are installed"
	ewarn "for running logtalk with selected Prolog compilers:"
	ewarn "B-Prolog: /usr/bin/bplgt"
	ewarn "CxProlog: /usr/bin/cxlgt"
	ewarn "ECLiPSe: /usr/bin/eclipselgt"
	ewarn "GNU Prolog: /usr/bin/gplgt"
	ewarn "JIProlog: /usr/bin/jiplgt"
	ewarn "Lean Prolog: /usr/bin/lplgt"
	ewarn "Qu-Prolog: /usr/bin/qplgt"
	ewarn "Quintus Prolog: /usr/bin/quintuslgt"
	ewarn "SICStus Prolog: /usr/bin/sicstuslgt"
	ewarn "SWI Prolog: /usr/bin/swilgt"
	ewarn "XSB: /usr/bin/xsblgt"
	ewarn "XSB MT: /usr/bin/xsbmtlgt"
	ewarn "YAP: /usr/bin/yaplgt"
	ewarn ""

	ewarn "The environment has been set up to make the above"
	ewarn "integration scripts find files automatically for logtalk."
	ewarn "Please run 'etc-update && source /etc/profile' to update"
	ewarn "the environment now, otherwise it will be updated at next"
	ewarn "login."
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
