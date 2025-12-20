# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DTD_FILE="scrollkeeper-omf.dtd"

DESCRIPTION="DTD from the Scrollkeeper package"
HOMEPAGE="https://scrollkeeper.sourceforge.net/"
SRC_URI="https://scrollkeeper.sourceforge.net/dtds/scrollkeeper-omf-1.0/${DTD_FILE}"
S="${WORKDIR}"

LICENSE="FDL-1.1"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"

RDEPEND=">=dev-libs/libxml2-2.4.19"
DEPEND="${RDEPEND}"

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
	"${EROOT}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//OMF//DTD Scrollkeeper OMF Variant V1.0//EN" \
		"${EROOT}"/usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"/etc/xml/catalog

	# Install catalog entry for calls like: xmllint --dtdvalid URL ...
	"${EROOT}"/usr/bin/xmlcatalog --noout --add "system" \
		"${SRC_URI}" \
		"${EROOT}"/usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"/etc/xml/catalog
}

pkg_postrm() {
	# Remove all sk-dtd from the cache
	einfo "Cleaning catalog..."

	"${EROOT}"/usr/bin/xmlcatalog --noout --del \
		"${EROOT}"/usr/share/xml/scrollkeeper/dtds/${DTD_FILE} \
		"${EROOT}"/etc/xml/catalog
}
