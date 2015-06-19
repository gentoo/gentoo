# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/scrollkeeper-dtd/scrollkeeper-dtd-1.0.ebuild,v 1.7 2015/03/10 20:49:30 vapier Exp $

EAPI="3"

DTD_FILE="scrollkeeper-omf.dtd"

DESCRIPTION="DTD from the Scrollkeeper package"
HOMEPAGE="http://scrollkeeper.sourceforge.net/"
SRC_URI="http://scrollkeeper.sourceforge.net/dtds/scrollkeeper-omf-1.0/${DTD_FILE}"

LICENSE="FDL-1.1"
SLOT="1.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.4.19"
DEPEND="${RDEPEND}
	!<app-text/scrollkeeper-9999-r1"

src_unpack() { :; }

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/xml/scrollkeeper/dtds
	doins "${DISTDIR}/${DTD_FILE}"
}

pkg_postinst() {
	einfo "Installing catalog..."

	# Install regular DOCTYPE catalog entry
	"${EROOT}"usr/bin/xmlcatalog --noout --add "public" \
		"-//OMF//DTD Scrollkeeper OMF Variant V1.0//EN" \
		"${EROOT}"usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"etc/xml/catalog

	# Install catalog entry for calls like: xmllint --dtdvalid URL ...
	"${EROOT}"usr/bin/xmlcatalog --noout --add "system" \
		"${SRC_URI}" \
		"${EROOT}"usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"etc/xml/catalog
}

pkg_postrm() {
	# Remove all sk-dtd from the cache
	einfo "Cleaning catalog..."

	"${EROOT}"usr/bin/xmlcatalog --noout --del \
		"${EROOT}"usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"etc/xml/catalog
}
